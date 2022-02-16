; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -basic-aa -gvn -enable-load-pre -S | FileCheck %s
; RUN: opt < %s -aa-pipeline=basic-aa -passes=gvn -enable-load-pre -S | FileCheck %s
; RUN: opt < %s -aa-pipeline=basic-aa -passes="gvn<load-pre>" -enable-load-pre=false -S | FileCheck %s

target datalayout = "e-m:e-i64:64-i128:128-n32:64-S128"
target triple = "aarch64--linux-gnu"

define double @foo(i32 %stat, i32 %i, double** %p) {
; CHECK-LABEL: @foo(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    switch i32 [[STAT:%.*]], label [[SW_DEFAULT:%.*]] [
; CHECK-NEXT:    i32 0, label [[SW_BB:%.*]]
; CHECK-NEXT:    i32 1, label [[SW_BB]]
; CHECK-NEXT:    i32 2, label [[ENTRY_SW_BB2_CRIT_EDGE:%.*]]
; CHECK-NEXT:    ]
; CHECK:       entry.sw.bb2_crit_edge:
; CHECK-NEXT:    [[DOTPRE:%.*]] = load double*, double** [[P:%.*]], align 8
; CHECK-NEXT:    [[DOTPRE1:%.*]] = sext i32 [[I:%.*]] to i64
; CHECK-NEXT:    [[ARRAYIDX5_PHI_TRANS_INSERT:%.*]] = getelementptr inbounds double, double* [[DOTPRE]], i64 [[DOTPRE1]]
; CHECK-NEXT:    [[DOTPRE2:%.*]] = load double, double* [[ARRAYIDX5_PHI_TRANS_INSERT]], align 8
; CHECK-NEXT:    br label [[SW_BB2:%.*]]
; CHECK:       sw.bb:
; CHECK-NEXT:    [[IDXPROM:%.*]] = sext i32 [[I]] to i64
; CHECK-NEXT:    [[TMP0:%.*]] = load double*, double** [[P]], align 8
; CHECK-NEXT:    [[ARRAYIDX1:%.*]] = getelementptr inbounds double, double* [[TMP0]], i64 [[IDXPROM]]
; CHECK-NEXT:    [[TMP1:%.*]] = load double, double* [[ARRAYIDX1]], align 8
; CHECK-NEXT:    [[SUB:%.*]] = fsub double [[TMP1]], 1.000000e+00
; CHECK-NEXT:    [[CMP:%.*]] = fcmp olt double [[SUB]], 0.000000e+00
; CHECK-NEXT:    br i1 [[CMP]], label [[IF_THEN:%.*]], label [[IF_END:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    br label [[RETURN:%.*]]
; CHECK:       if.end:
; CHECK-NEXT:    br label [[SW_BB2]]
; CHECK:       sw.bb2:
; CHECK-NEXT:    [[TMP2:%.*]] = phi double [ [[DOTPRE2]], [[ENTRY_SW_BB2_CRIT_EDGE]] ], [ [[TMP1]], [[IF_END]] ]
; CHECK-NEXT:    [[IDXPROM3_PRE_PHI:%.*]] = phi i64 [ [[DOTPRE1]], [[ENTRY_SW_BB2_CRIT_EDGE]] ], [ [[IDXPROM]], [[IF_END]] ]
; CHECK-NEXT:    [[TMP3:%.*]] = phi double* [ [[DOTPRE]], [[ENTRY_SW_BB2_CRIT_EDGE]] ], [ [[TMP0]], [[IF_END]] ]
; CHECK-NEXT:    [[ARRAYIDX5:%.*]] = getelementptr inbounds double, double* [[TMP3]], i64 [[IDXPROM3_PRE_PHI]]
; CHECK-NEXT:    [[SUB6:%.*]] = fsub double 3.000000e+00, [[TMP2]]
; CHECK-NEXT:    store double [[SUB6]], double* [[ARRAYIDX5]], align 8
; CHECK-NEXT:    br label [[RETURN]]
; CHECK:       sw.default:
; CHECK-NEXT:    br label [[RETURN]]
; CHECK:       return:
; CHECK-NEXT:    [[RETVAL_0:%.*]] = phi double [ 0.000000e+00, [[SW_DEFAULT]] ], [ [[SUB6]], [[SW_BB2]] ], [ [[SUB]], [[IF_THEN]] ]
; CHECK-NEXT:    ret double [[RETVAL_0]]
;
entry:
  switch i32 %stat, label %sw.default [
  i32 0, label %sw.bb
  i32 1, label %sw.bb
  i32 2, label %sw.bb2
  ]

sw.bb:                                            ; preds = %entry, %entry
  %idxprom = sext i32 %i to i64
  %arrayidx = getelementptr inbounds double*, double** %p, i64 0
  %0 = load double*, double** %arrayidx, align 8
  %arrayidx1 = getelementptr inbounds double, double* %0, i64 %idxprom
  %1 = load double, double* %arrayidx1, align 8
  %sub = fsub double %1, 1.000000e+00
  %cmp = fcmp olt double %sub, 0.000000e+00
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %sw.bb
  br label %return

if.end:                                           ; preds = %sw.bb
  br label %sw.bb2

sw.bb2:                                           ; preds = %if.end, %entry
  %idxprom3 = sext i32 %i to i64
  %arrayidx4 = getelementptr inbounds double*, double** %p, i64 0
  %2 = load double*, double** %arrayidx4, align 8
  %arrayidx5 = getelementptr inbounds double, double* %2, i64 %idxprom3
  %3 = load double, double* %arrayidx5, align 8
  %sub6 = fsub double 3.000000e+00, %3
  store double %sub6, double* %arrayidx5
  br label %return

sw.default:                                       ; preds = %entry
  br label %return

return:                                           ; preds = %sw.default, %sw.bb2, %if.then
  %retval.0 = phi double [ 0.000000e+00, %sw.default ], [ %sub6, %sw.bb2 ], [ %sub, %if.then ]
  ret double %retval.0
}

; The load causes the GEP's operands to be PREd earlier than normal. The
; resulting sext ends up in pre.dest and in the GVN system before that BB is
; actually processed. Make sure we can deal with the situation.

define void @test_shortcut_safe(i1 %tst, i32 %p1, i32* %a) {
; CHECK-LABEL: @test_shortcut_safe(
; CHECK-NEXT:    br i1 [[TST:%.*]], label [[SEXT1:%.*]], label [[PRE_DEST:%.*]]
; CHECK:       pre.dest:
; CHECK-NEXT:    [[DOTPRE:%.*]] = sext i32 [[P1:%.*]] to i64
; CHECK-NEXT:    br label [[SEXT_USE:%.*]]
; CHECK:       sext1:
; CHECK-NEXT:    [[IDXPROM:%.*]] = sext i32 [[P1]] to i64
; CHECK-NEXT:    br label [[SEXT_USE]]
; CHECK:       sext.use:
; CHECK-NEXT:    [[IDXPROM2_PRE_PHI:%.*]] = phi i64 [ [[IDXPROM]], [[SEXT1]] ], [ [[DOTPRE]], [[PRE_DEST]] ]
; CHECK-NEXT:    [[ARRAYIDX3:%.*]] = getelementptr inbounds i32, i32* [[A:%.*]], i64 [[IDXPROM2_PRE_PHI]]
; CHECK-NEXT:    [[VAL:%.*]] = load i32, i32* [[ARRAYIDX3]], align 4
; CHECK-NEXT:    tail call void @g(i32 [[VAL]])
; CHECK-NEXT:    br label [[PRE_DEST]]
;

  br i1 %tst, label %sext1, label %pre.dest

pre.dest:
  br label %sext.use

sext1:
  %idxprom = sext i32 %p1 to i64
  br label %sext.use

sext.use:
  %idxprom2 = sext i32 %p1 to i64
  %arrayidx3 = getelementptr inbounds i32, i32* %a, i64 %idxprom2
  %val = load i32, i32* %arrayidx3, align 4
  tail call void (i32) @g(i32 %val)
  br label %pre.dest
}

declare void @g(i32)
