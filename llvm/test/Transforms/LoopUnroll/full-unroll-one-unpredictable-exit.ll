; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -loop-unroll %s | FileCheck %s

; In both cases, we have one unpredictable exit and one IV-based exit with
; known trip count. We can fully unroll against the latter. In one of the
; examples the IV-based exit is the latch exit, in the other the non-latch
; exit. After full unrolling, the functions fold to ret i1 true.

define i1 @test_latch() {
; CHECK-LABEL: @test_latch(
; CHECK-NEXT:  start:
; CHECK-NEXT:    [[A1:%.*]] = alloca [2 x i64], align 8
; CHECK-NEXT:    [[A2:%.*]] = alloca [2 x i64], align 8
; CHECK-NEXT:    [[A1_0:%.*]] = getelementptr inbounds [2 x i64], [2 x i64]* [[A1]], i64 0, i64 0
; CHECK-NEXT:    store i64 -5015437470765251660, i64* [[A1_0]], align 8
; CHECK-NEXT:    [[A1_1:%.*]] = getelementptr inbounds [2 x i64], [2 x i64]* [[A1]], i64 0, i64 1
; CHECK-NEXT:    store i64 -8661621401413125213, i64* [[A1_1]], align 8
; CHECK-NEXT:    [[A2_0:%.*]] = getelementptr inbounds [2 x i64], [2 x i64]* [[A2]], i64 0, i64 0
; CHECK-NEXT:    store i64 -5015437470765251660, i64* [[A2_0]], align 8
; CHECK-NEXT:    [[A2_1:%.*]] = getelementptr inbounds [2 x i64], [2 x i64]* [[A2]], i64 0, i64 1
; CHECK-NEXT:    store i64 -8661621401413125213, i64* [[A2_1]], align 8
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[GEP1:%.*]] = getelementptr inbounds [2 x i64], [2 x i64]* [[A1]], i64 0, i64 0
; CHECK-NEXT:    [[GEP2:%.*]] = getelementptr inbounds [2 x i64], [2 x i64]* [[A2]], i64 0, i64 0
; CHECK-NEXT:    [[LOAD1:%.*]] = load i64, i64* [[GEP1]], align 8
; CHECK-NEXT:    [[LOAD2:%.*]] = load i64, i64* [[GEP2]], align 8
; CHECK-NEXT:    [[EXITCOND2:%.*]] = icmp eq i64 [[LOAD1]], [[LOAD2]]
; CHECK-NEXT:    br i1 [[EXITCOND2]], label [[LATCH:%.*]], label [[EXIT:%.*]]
; CHECK:       latch:
; CHECK-NEXT:    [[GEP1_1:%.*]] = getelementptr inbounds [2 x i64], [2 x i64]* [[A1]], i64 0, i64 1
; CHECK-NEXT:    [[GEP2_1:%.*]] = getelementptr inbounds [2 x i64], [2 x i64]* [[A2]], i64 0, i64 1
; CHECK-NEXT:    [[LOAD1_1:%.*]] = load i64, i64* [[GEP1_1]], align 8
; CHECK-NEXT:    [[LOAD2_1:%.*]] = load i64, i64* [[GEP2_1]], align 8
; CHECK-NEXT:    [[EXITCOND2_1:%.*]] = icmp eq i64 [[LOAD1_1]], [[LOAD2_1]]
; CHECK-NEXT:    br i1 [[EXITCOND2_1]], label [[LATCH_1:%.*]], label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    [[EXIT_VAL:%.*]] = phi i1 [ false, [[LOOP]] ], [ false, [[LATCH]] ], [ true, [[LATCH_1]] ]
; CHECK-NEXT:    ret i1 [[EXIT_VAL]]
; CHECK:       latch.1:
; CHECK-NEXT:    br label [[EXIT]]
;
start:
  %a1 = alloca [2 x i64], align 8
  %a2 = alloca [2 x i64], align 8
  %a1.0 = getelementptr inbounds [2 x i64], [2 x i64]* %a1, i64 0, i64 0
  store i64 -5015437470765251660, i64* %a1.0, align 8
  %a1.1 = getelementptr inbounds [2 x i64], [2 x i64]* %a1, i64 0, i64 1
  store i64 -8661621401413125213, i64* %a1.1, align 8
  %a2.0 = getelementptr inbounds [2 x i64], [2 x i64]* %a2, i64 0, i64 0
  store i64 -5015437470765251660, i64* %a2.0, align 8
  %a2.1 = getelementptr inbounds [2 x i64], [2 x i64]* %a2, i64 0, i64 1
  store i64 -8661621401413125213, i64* %a2.1, align 8
  br label %loop

loop:
  %iv = phi i64 [ 0, %start ], [ %iv.next, %latch ]
  %gep1 = getelementptr inbounds [2 x i64], [2 x i64]* %a1, i64 0, i64 %iv
  %gep2 = getelementptr inbounds [2 x i64], [2 x i64]* %a2, i64 0, i64 %iv
  %load1 = load i64, i64* %gep1, align 8
  %load2 = load i64, i64* %gep2, align 8
  %exitcond2 = icmp eq i64 %load1, %load2
  br i1 %exitcond2, label %latch, label %exit

latch:
  %iv.next = add nuw nsw i64 %iv, 1
  %exitcond = icmp eq i64 %iv.next, 2
  br i1 %exitcond, label %exit, label %loop

exit:
  %exit.val = phi i1 [ true, %latch ], [ false, %loop ]
  ret i1 %exit.val
}

define i1 @test_non_latch() {
; CHECK-LABEL: @test_non_latch(
; CHECK-NEXT:  start:
; CHECK-NEXT:    [[A1:%.*]] = alloca [2 x i64], align 8
; CHECK-NEXT:    [[A2:%.*]] = alloca [2 x i64], align 8
; CHECK-NEXT:    [[A1_0:%.*]] = getelementptr inbounds [2 x i64], [2 x i64]* [[A1]], i64 0, i64 0
; CHECK-NEXT:    store i64 -5015437470765251660, i64* [[A1_0]], align 8
; CHECK-NEXT:    [[A1_1:%.*]] = getelementptr inbounds [2 x i64], [2 x i64]* [[A1]], i64 0, i64 1
; CHECK-NEXT:    store i64 -8661621401413125213, i64* [[A1_1]], align 8
; CHECK-NEXT:    [[A2_0:%.*]] = getelementptr inbounds [2 x i64], [2 x i64]* [[A2]], i64 0, i64 0
; CHECK-NEXT:    store i64 -5015437470765251660, i64* [[A2_0]], align 8
; CHECK-NEXT:    [[A2_1:%.*]] = getelementptr inbounds [2 x i64], [2 x i64]* [[A2]], i64 0, i64 1
; CHECK-NEXT:    store i64 -8661621401413125213, i64* [[A2_1]], align 8
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    br label [[LATCH:%.*]]
; CHECK:       latch:
; CHECK-NEXT:    [[GEP1:%.*]] = getelementptr inbounds [2 x i64], [2 x i64]* [[A1]], i64 0, i64 0
; CHECK-NEXT:    [[GEP2:%.*]] = getelementptr inbounds [2 x i64], [2 x i64]* [[A2]], i64 0, i64 0
; CHECK-NEXT:    [[LOAD1:%.*]] = load i64, i64* [[GEP1]], align 8
; CHECK-NEXT:    [[LOAD2:%.*]] = load i64, i64* [[GEP2]], align 8
; CHECK-NEXT:    [[EXITCOND2:%.*]] = icmp eq i64 [[LOAD1]], [[LOAD2]]
; CHECK-NEXT:    br i1 [[EXITCOND2]], label [[LOOP_1:%.*]], label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    [[EXIT_VAL:%.*]] = phi i1 [ false, [[LATCH]] ], [ false, [[LATCH_1:%.*]] ], [ true, [[LOOP_2:%.*]] ], [ false, [[LATCH_2:%.*]] ]
; CHECK-NEXT:    ret i1 [[EXIT_VAL]]
; CHECK:       loop.1:
; CHECK-NEXT:    br label [[LATCH_1]]
; CHECK:       latch.1:
; CHECK-NEXT:    [[GEP1_1:%.*]] = getelementptr inbounds [2 x i64], [2 x i64]* [[A1]], i64 0, i64 1
; CHECK-NEXT:    [[GEP2_1:%.*]] = getelementptr inbounds [2 x i64], [2 x i64]* [[A2]], i64 0, i64 1
; CHECK-NEXT:    [[LOAD1_1:%.*]] = load i64, i64* [[GEP1_1]], align 8
; CHECK-NEXT:    [[LOAD2_1:%.*]] = load i64, i64* [[GEP2_1]], align 8
; CHECK-NEXT:    [[EXITCOND2_1:%.*]] = icmp eq i64 [[LOAD1_1]], [[LOAD2_1]]
; CHECK-NEXT:    br i1 [[EXITCOND2_1]], label [[LOOP_2]], label [[EXIT]]
; CHECK:       loop.2:
; CHECK-NEXT:    br i1 true, label [[EXIT]], label [[LATCH_2]]
; CHECK:       latch.2:
; CHECK-NEXT:    br label [[EXIT]]
;
start:
  %a1 = alloca [2 x i64], align 8
  %a2 = alloca [2 x i64], align 8
  %a1.0 = getelementptr inbounds [2 x i64], [2 x i64]* %a1, i64 0, i64 0
  store i64 -5015437470765251660, i64* %a1.0, align 8
  %a1.1 = getelementptr inbounds [2 x i64], [2 x i64]* %a1, i64 0, i64 1
  store i64 -8661621401413125213, i64* %a1.1, align 8
  %a2.0 = getelementptr inbounds [2 x i64], [2 x i64]* %a2, i64 0, i64 0
  store i64 -5015437470765251660, i64* %a2.0, align 8
  %a2.1 = getelementptr inbounds [2 x i64], [2 x i64]* %a2, i64 0, i64 1
  store i64 -8661621401413125213, i64* %a2.1, align 8
  br label %loop

loop:
  %iv = phi i64 [ 0, %start ], [ %iv.next, %latch ]
  %exitcond = icmp eq i64 %iv, 2
  br i1 %exitcond, label %exit, label %latch

latch:
  %iv.next = add nuw nsw i64 %iv, 1
  %gep1 = getelementptr inbounds [2 x i64], [2 x i64]* %a1, i64 0, i64 %iv
  %gep2 = getelementptr inbounds [2 x i64], [2 x i64]* %a2, i64 0, i64 %iv
  %load1 = load i64, i64* %gep1, align 8
  %load2 = load i64, i64* %gep2, align 8
  %exitcond2 = icmp eq i64 %load1, %load2
  br i1 %exitcond2, label %loop, label %exit

exit:
  %exit.val = phi i1 [ false, %latch ], [ true, %loop ]
  ret i1 %exit.val
}
