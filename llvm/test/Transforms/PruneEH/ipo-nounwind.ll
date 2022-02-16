; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -prune-eh -enable-new-pm=0 < %s | FileCheck --check-prefixes=ALL,OLDPM %s
; RUN: opt -S -passes='function-attrs,function(simplifycfg)' < %s | FileCheck --check-prefixes=ALL,NEWPM %s

declare void @may_throw()

; @callee below may be an optimized form of this function, which can
; throw at runtime (see r265762 for more details):
;
; define linkonce_odr void @callee(i32* %ptr) noinline {
; entry:
;   %val0 = load atomic i32, i32* %ptr unordered, align 4
;   %val1 = load atomic i32, i32* %ptr unordered, align 4
;   %cmp = icmp eq i32 %val0, %val1
;   br i1 %cmp, label %left, label %right

; left:
;   ret void

; right:
;   call void @may_throw()
;   ret void
; }

define linkonce_odr void @callee(i32* %ptr) noinline {
; ALL-LABEL: @callee(
; ALL-NEXT:    ret void
;
  ret void
}

define i32 @caller(i32* %ptr) personality i32 3 {
; OLDPM-LABEL: @caller(
; OLDPM-NEXT:  entry:
; OLDPM-NEXT:    invoke void @callee(i32* [[PTR:%.*]])
; OLDPM-NEXT:    to label [[NORMAL:%.*]] unwind label [[UNWIND:%.*]]
; OLDPM:       normal:
; OLDPM-NEXT:    ret i32 1
; OLDPM:       unwind:
; OLDPM-NEXT:    [[RES:%.*]] = landingpad { i8*, i32 }
; OLDPM-NEXT:    cleanup
; OLDPM-NEXT:    ret i32 2
;
; NEWPM-LABEL: @caller(
; NEWPM-NEXT:  entry:
; NEWPM-NEXT:    invoke void @callee(i32* [[PTR:%.*]])
; NEWPM-NEXT:    to label [[COMMON_RET:%.*]] unwind label [[UNWIND:%.*]]
; NEWPM:       common.ret:
; NEWPM-NEXT:    [[COMMON_RET_OP:%.*]] = phi i32 [ 2, [[UNWIND]] ], [ 1, [[ENTRY:%.*]] ]
; NEWPM-NEXT:    ret i32 [[COMMON_RET_OP]]
; NEWPM:       unwind:
; NEWPM-NEXT:    [[RES:%.*]] = landingpad { i8*, i32 }
; NEWPM-NEXT:    cleanup
; NEWPM-NEXT:    br label [[COMMON_RET]]
;
entry:
  invoke void @callee(i32* %ptr)
  to label %normal unwind label %unwind

normal:
  ret i32 1

unwind:
  %res = landingpad { i8*, i32 }
  cleanup
  ret i32 2
}
