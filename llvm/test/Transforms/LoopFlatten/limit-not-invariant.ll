; NOTE: Assertions have been autogenerated by utils/update_test_checks.py

; RUN: opt < %s -S -loop-flatten -verify-loop-info -verify-dom-info -verify-scev -verify | FileCheck %s

target datalayout = "e-m:e-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128"

define dso_local void @inner_limit_not_invariant(i32 %N, i32* nocapture %C, i16* nocapture readonly %A, i16 %val) {
; CHECK-LABEL: @inner_limit_not_invariant(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP26_NOT:%.*]] = icmp eq i32 [[N:%.*]], 0
; CHECK-NEXT:    br i1 [[CMP26_NOT]], label [[FOR_END12:%.*]], label [[FOR_COND1_PREHEADER_LR_PH:%.*]]
; CHECK:       for.cond1.preheader.lr.ph:
; CHECK-NEXT:    [[CONV4:%.*]] = sext i16 [[VAL:%.*]] to i32
; CHECK-NEXT:    br label [[FOR_COND1_PREHEADER_US:%.*]]
; CHECK:       for.cond1.preheader.us:
; CHECK-NEXT:    [[I_027_US:%.*]] = phi i32 [ 0, [[FOR_COND1_PREHEADER_LR_PH]] ], [ [[INC11_US:%.*]], [[FOR_COND1_FOR_INC10_CRIT_EDGE_US:%.*]] ]
; CHECK-NEXT:    [[MUL_US:%.*]] = mul i32 [[I_027_US]], [[N]]
; CHECK-NEXT:    [[WIDE_TRIP_COUNT:%.*]] = zext i32 [[N]] to i64
; CHECK-NEXT:    br label [[FOR_BODY3_US:%.*]]
; CHECK:       for.body3.us:
; CHECK-NEXT:    [[INDVARS_IV:%.*]] = phi i64 [ 0, [[FOR_COND1_PREHEADER_US]] ], [ [[INDVARS_IV_NEXT:%.*]], [[FOR_BODY3_US]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = trunc i64 [[INDVARS_IV]] to i32
; CHECK-NEXT:    [[ADD_US:%.*]] = add i32 [[TMP0]], [[MUL_US]]
; CHECK-NEXT:    [[IDXPROM_US:%.*]] = zext i32 [[ADD_US]] to i64
; CHECK-NEXT:    [[ARRAYIDX_US:%.*]] = getelementptr inbounds i16, i16* [[A:%.*]], i64 [[IDXPROM_US]]
; CHECK-NEXT:    [[TMP1:%.*]] = load i16, i16* [[ARRAYIDX_US]], align 2
; CHECK-NEXT:    [[CONV_US:%.*]] = sext i16 [[TMP1]] to i32
; CHECK-NEXT:    [[MUL5_US:%.*]] = mul nsw i32 [[CONV_US]], [[CONV4]]
; CHECK-NEXT:    [[ARRAYIDX9_US:%.*]] = getelementptr inbounds i32, i32* [[C:%.*]], i64 [[IDXPROM_US]]
; CHECK-NEXT:    store i32 [[MUL5_US]], i32* [[ARRAYIDX9_US]], align 4
; CHECK-NEXT:    [[INDVARS_IV_NEXT]] = add nuw nsw i64 [[INDVARS_IV]], 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp ne i64 [[INDVARS_IV_NEXT]], [[WIDE_TRIP_COUNT]]
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[FOR_BODY3_US]], label [[FOR_COND1_FOR_INC10_CRIT_EDGE_US]]
; CHECK:       for.cond1.for.inc10_crit_edge.us:
; CHECK-NEXT:    [[INC11_US]] = add nuw i32 [[I_027_US]], 1
; CHECK-NEXT:    [[EXITCOND29:%.*]] = icmp ne i32 [[INC11_US]], [[N]]
; CHECK-NEXT:    br i1 [[EXITCOND29]], label [[FOR_COND1_PREHEADER_US]], label [[FOR_END12_LOOPEXIT:%.*]]
; CHECK:       for.end12.loopexit:
; CHECK-NEXT:    br label [[FOR_END12]]
; CHECK:       for.end12:
; CHECK-NEXT:    ret void
;
entry:
  %cmp26.not = icmp eq i32 %N, 0
  br i1 %cmp26.not, label %for.end12, label %for.cond1.preheader.lr.ph

for.cond1.preheader.lr.ph:
  %conv4 = sext i16 %val to i32
  br label %for.cond1.preheader.us

for.cond1.preheader.us:
  %i.027.us = phi i32 [ 0, %for.cond1.preheader.lr.ph ], [ %inc11.us, %for.cond1.for.inc10_crit_edge.us ]
  %mul.us = mul i32 %i.027.us, %N
  %wide.trip.count = zext i32 %N to i64
  br label %for.body3.us

for.body3.us:
  %indvars.iv = phi i64 [ 0, %for.cond1.preheader.us ], [ %indvars.iv.next, %for.body3.us ]
  %0 = trunc i64 %indvars.iv to i32
  %add.us = add i32 %0, %mul.us
  %idxprom.us = zext i32 %add.us to i64
  %arrayidx.us = getelementptr inbounds i16, i16* %A, i64 %idxprom.us
  %1 = load i16, i16* %arrayidx.us, align 2
  %conv.us = sext i16 %1 to i32
  %mul5.us = mul nsw i32 %conv.us, %conv4
  %arrayidx9.us = getelementptr inbounds i32, i32* %C, i64 %idxprom.us
  store i32 %mul5.us, i32* %arrayidx9.us, align 4
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %exitcond = icmp ne i64 %indvars.iv.next, %wide.trip.count
  br i1 %exitcond, label %for.body3.us, label %for.cond1.for.inc10_crit_edge.us

for.cond1.for.inc10_crit_edge.us:
  %inc11.us = add nuw i32 %i.027.us, 1
  %exitcond29 = icmp ne i32 %inc11.us, %N
  br i1 %exitcond29, label %for.cond1.preheader.us, label %for.end12.loopexit

for.end12.loopexit:
  br label %for.end12

for.end12:
  ret void
}

define dso_local void @outer_limit_not_invariant(i32 %N, i32* nocapture %C, i16* nocapture readonly %A, i16 %val, i64 %M) {
; CHECK-LABEL: @outer_limit_not_invariant(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP26_NOT:%.*]] = icmp eq i32 [[N:%.*]], 0
; CHECK-NEXT:    br i1 [[CMP26_NOT]], label [[FOR_END12:%.*]], label [[FOR_COND1_PREHEADER_LR_PH:%.*]]
; CHECK:       for.cond1.preheader.lr.ph:
; CHECK-NEXT:    [[CONV4:%.*]] = sext i16 [[VAL:%.*]] to i32
; CHECK-NEXT:    br label [[FOR_COND1_PREHEADER_US:%.*]]
; CHECK:       for.cond1.preheader.us:
; CHECK-NEXT:    [[I_027_US:%.*]] = phi i32 [ 0, [[FOR_COND1_PREHEADER_LR_PH]] ], [ [[INC11_US:%.*]], [[FOR_COND1_FOR_INC10_CRIT_EDGE_US:%.*]] ]
; CHECK-NEXT:    [[MUL_US:%.*]] = mul i32 [[I_027_US]], [[N]]
; CHECK-NEXT:    [[TRUNC_TRIP_COUNT:%.*]] = trunc i64 [[M:%.*]] to i32
; CHECK-NEXT:    br label [[FOR_BODY3_US:%.*]]
; CHECK:       for.body3.us:
; CHECK-NEXT:    [[INDVARS_IV:%.*]] = phi i64 [ 0, [[FOR_COND1_PREHEADER_US]] ], [ [[INDVARS_IV_NEXT:%.*]], [[FOR_BODY3_US]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = trunc i64 [[INDVARS_IV]] to i32
; CHECK-NEXT:    [[ADD_US:%.*]] = add i32 [[TMP0]], [[MUL_US]]
; CHECK-NEXT:    [[IDXPROM_US:%.*]] = zext i32 [[ADD_US]] to i64
; CHECK-NEXT:    [[ARRAYIDX_US:%.*]] = getelementptr inbounds i16, i16* [[A:%.*]], i64 [[IDXPROM_US]]
; CHECK-NEXT:    [[TMP1:%.*]] = load i16, i16* [[ARRAYIDX_US]], align 2
; CHECK-NEXT:    [[CONV_US:%.*]] = sext i16 [[TMP1]] to i32
; CHECK-NEXT:    [[MUL5_US:%.*]] = mul nsw i32 [[CONV_US]], [[CONV4]]
; CHECK-NEXT:    [[ARRAYIDX9_US:%.*]] = getelementptr inbounds i32, i32* [[C:%.*]], i64 [[IDXPROM_US]]
; CHECK-NEXT:    store i32 [[MUL5_US]], i32* [[ARRAYIDX9_US]], align 4
; CHECK-NEXT:    [[INDVARS_IV_NEXT]] = add nuw nsw i64 [[INDVARS_IV]], 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp ne i64 [[INDVARS_IV_NEXT]], [[M]]
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[FOR_BODY3_US]], label [[FOR_COND1_FOR_INC10_CRIT_EDGE_US]]
; CHECK:       for.cond1.for.inc10_crit_edge.us:
; CHECK-NEXT:    [[INC11_US]] = add nuw i32 [[I_027_US]], 1
; CHECK-NEXT:    [[EXITCOND29:%.*]] = icmp ne i32 [[INC11_US]], [[TRUNC_TRIP_COUNT]]
; CHECK-NEXT:    br i1 [[EXITCOND29]], label [[FOR_COND1_PREHEADER_US]], label [[FOR_END12_LOOPEXIT:%.*]]
; CHECK:       for.end12.loopexit:
; CHECK-NEXT:    br label [[FOR_END12]]
; CHECK:       for.end12:
; CHECK-NEXT:    ret void
;
entry:
  %cmp26.not = icmp eq i32 %N, 0
  br i1 %cmp26.not, label %for.end12, label %for.cond1.preheader.lr.ph

for.cond1.preheader.lr.ph:
  %conv4 = sext i16 %val to i32
  br label %for.cond1.preheader.us

for.cond1.preheader.us:
  %i.027.us = phi i32 [ 0, %for.cond1.preheader.lr.ph ], [ %inc11.us, %for.cond1.for.inc10_crit_edge.us ]
  %mul.us = mul i32 %i.027.us, %N
  %trunc.trip.count = trunc i64 %M to i32
  br label %for.body3.us

for.body3.us:
  %indvars.iv = phi i64 [ 0, %for.cond1.preheader.us ], [ %indvars.iv.next, %for.body3.us ]
  %0 = trunc i64 %indvars.iv to i32
  %add.us = add i32 %0, %mul.us
  %idxprom.us = zext i32 %add.us to i64
  %arrayidx.us = getelementptr inbounds i16, i16* %A, i64 %idxprom.us
  %1 = load i16, i16* %arrayidx.us, align 2
  %conv.us = sext i16 %1 to i32
  %mul5.us = mul nsw i32 %conv.us, %conv4
  %arrayidx9.us = getelementptr inbounds i32, i32* %C, i64 %idxprom.us
  store i32 %mul5.us, i32* %arrayidx9.us, align 4
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %exitcond = icmp ne i64 %indvars.iv.next, %M
  br i1 %exitcond, label %for.body3.us, label %for.cond1.for.inc10_crit_edge.us

for.cond1.for.inc10_crit_edge.us:
  %inc11.us = add nuw i32 %i.027.us, 1
  %exitcond29 = icmp ne i32 %inc11.us, %trunc.trip.count
  br i1 %exitcond29, label %for.cond1.preheader.us, label %for.end12.loopexit

for.end12.loopexit:
  br label %for.end12

for.end12:
  ret void
}
