; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -simplifycfg -simplifycfg-require-and-preserve-domtree=1 -S | FileCheck %s

define i1 @qux(i8* %m, i8* %n, i8* %o, i8* %p) nounwind  {
; CHECK-LABEL: @qux(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[T7:%.*]] = icmp eq i8* [[M:%.*]], [[N:%.*]]
; CHECK-NEXT:    [[T15:%.*]] = icmp eq i8* [[O:%.*]], [[P:%.*]]
; CHECK-NEXT:    [[SPEC_SELECT:%.*]] = select i1 [[T7]], i1 [[T15]], i1 false, !prof [[PROF0:![0-9]+]]
; CHECK-NEXT:    ret i1 [[SPEC_SELECT]]
;
entry:
  %t7 = icmp eq i8* %m, %n
  br i1 %t7, label %bb, label %UnifiedReturnBlock, !prof !0

bb:
  %t15 = icmp eq i8* %o, %p
  br label %UnifiedReturnBlock

UnifiedReturnBlock:
  %result = phi i1 [ 0, %entry ], [ %t15, %bb ]
  ret i1 %result

}

@a = external dso_local global i32, align 4

define i32 @PR50638() {
; CHECK-LABEL: @PR50638(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    store i32 0, i32* @a, align 4
; CHECK-NEXT:    ret i32 0
;
entry:
  store i32 0, i32* @a, align 4
  br label %pre.for

pre.for:
  %tobool.not = phi i1 [ false, %for ], [ true, %entry ]
  br i1 %tobool.not, label %end, label %for

for:
  %cmp = phi i1 [ true, %pre.for ], [ false, %post.for ]
  %storemerge = phi i32 [ 0, %pre.for ], [ 1, %post.for ]
  store i32 %storemerge, i32* @a, align 4
  br i1 %cmp, label %post.for, label %pre.for

post.for:
  br label %for

end:
  ret i32 0
}

!0 = !{!"branch_weights", i32 4, i32 64}
