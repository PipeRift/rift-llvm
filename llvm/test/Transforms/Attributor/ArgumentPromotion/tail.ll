; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --check-attributes --check-globals
; RUN: opt -attributor -enable-new-pm=0 -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=2 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_NPM,NOT_CGSCC_OPM,NOT_TUNIT_NPM,IS__TUNIT____,IS________OPM,IS__TUNIT_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=2 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_OPM,NOT_CGSCC_NPM,NOT_TUNIT_OPM,IS__TUNIT____,IS________NPM,IS__TUNIT_NPM
; RUN: opt -attributor-cgscc -enable-new-pm=0 -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_NPM,IS__CGSCC____,IS________OPM,IS__CGSCC_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor-cgscc -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_OPM,IS__CGSCC____,IS________NPM,IS__CGSCC_NPM
; PR14710

target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

%pair = type { i32, i32 }

declare i8* @foo(%pair*)

define internal void @bar(%pair* byval(%pair) %Data) {
; IS__TUNIT_OPM-LABEL: define {{[^@]+}}@bar
; IS__TUNIT_OPM-SAME: (%pair* noalias nonnull byval([[PAIR:%.*]]) dereferenceable(8) [[DATA:%.*]]) {
; IS__TUNIT_OPM-NEXT:    [[TMP1:%.*]] = tail call i8* @foo(%pair* nonnull dereferenceable(8) [[DATA]])
; IS__TUNIT_OPM-NEXT:    ret void
;
; IS__TUNIT_NPM-LABEL: define {{[^@]+}}@bar
; IS__TUNIT_NPM-SAME: (i32 [[TMP0:%.*]], i32 [[TMP1:%.*]]) {
; IS__TUNIT_NPM-NEXT:    [[DATA_PRIV:%.*]] = alloca [[PAIR:%.*]], align 8
; IS__TUNIT_NPM-NEXT:    [[DATA_PRIV_CAST:%.*]] = bitcast %pair* [[DATA_PRIV]] to i32*
; IS__TUNIT_NPM-NEXT:    store i32 [[TMP0]], i32* [[DATA_PRIV_CAST]], align 4
; IS__TUNIT_NPM-NEXT:    [[DATA_PRIV_0_1:%.*]] = getelementptr [[PAIR]], %pair* [[DATA_PRIV]], i32 0, i32 1
; IS__TUNIT_NPM-NEXT:    store i32 [[TMP1]], i32* [[DATA_PRIV_0_1]], align 4
; IS__TUNIT_NPM-NEXT:    [[TMP3:%.*]] = call i8* @foo(%pair* nonnull dereferenceable(8) [[DATA_PRIV]])
; IS__TUNIT_NPM-NEXT:    ret void
;
; IS__CGSCC_OPM-LABEL: define {{[^@]+}}@bar
; IS__CGSCC_OPM-SAME: (%pair* noalias noundef nonnull byval([[PAIR:%.*]]) dereferenceable(8) [[DATA:%.*]]) {
; IS__CGSCC_OPM-NEXT:    [[TMP1:%.*]] = tail call i8* @foo(%pair* noundef nonnull dereferenceable(8) [[DATA]])
; IS__CGSCC_OPM-NEXT:    ret void
;
; IS__CGSCC_NPM-LABEL: define {{[^@]+}}@bar
; IS__CGSCC_NPM-SAME: (i32 [[TMP0:%.*]], i32 [[TMP1:%.*]]) {
; IS__CGSCC_NPM-NEXT:    [[DATA_PRIV:%.*]] = alloca [[PAIR:%.*]], align 8
; IS__CGSCC_NPM-NEXT:    [[DATA_PRIV_CAST:%.*]] = bitcast %pair* [[DATA_PRIV]] to i32*
; IS__CGSCC_NPM-NEXT:    store i32 [[TMP0]], i32* [[DATA_PRIV_CAST]], align 8
; IS__CGSCC_NPM-NEXT:    [[DATA_PRIV_0_1:%.*]] = getelementptr [[PAIR]], %pair* [[DATA_PRIV]], i32 0, i32 1
; IS__CGSCC_NPM-NEXT:    store i32 [[TMP1]], i32* [[DATA_PRIV_0_1]], align 4
; IS__CGSCC_NPM-NEXT:    [[TMP3:%.*]] = call i8* @foo(%pair* noundef nonnull align 8 dereferenceable(8) [[DATA_PRIV]])
; IS__CGSCC_NPM-NEXT:    ret void
;
  tail call i8* @foo(%pair* %Data)
  ret void
}

define void @zed(%pair* byval(%pair) %Data) {
; IS__TUNIT_OPM-LABEL: define {{[^@]+}}@zed
; IS__TUNIT_OPM-SAME: (%pair* noalias nocapture nonnull readonly byval([[PAIR:%.*]]) dereferenceable(8) [[DATA:%.*]]) {
; IS__TUNIT_OPM-NEXT:    call void @bar(%pair* noalias nocapture nonnull readonly byval([[PAIR]]) dereferenceable(8) [[DATA]])
; IS__TUNIT_OPM-NEXT:    ret void
;
; IS__TUNIT_NPM-LABEL: define {{[^@]+}}@zed
; IS__TUNIT_NPM-SAME: (%pair* noalias nocapture nonnull readonly byval([[PAIR:%.*]]) dereferenceable(8) [[DATA:%.*]]) {
; IS__TUNIT_NPM-NEXT:    [[DATA_CAST:%.*]] = bitcast %pair* [[DATA]] to i32*
; IS__TUNIT_NPM-NEXT:    [[TMP1:%.*]] = load i32, i32* [[DATA_CAST]], align 1
; IS__TUNIT_NPM-NEXT:    [[DATA_0_1:%.*]] = getelementptr [[PAIR]], %pair* [[DATA]], i32 0, i32 1
; IS__TUNIT_NPM-NEXT:    [[TMP2:%.*]] = load i32, i32* [[DATA_0_1]], align 1
; IS__TUNIT_NPM-NEXT:    call void @bar(i32 [[TMP1]], i32 [[TMP2]])
; IS__TUNIT_NPM-NEXT:    ret void
;
; IS__CGSCC_OPM-LABEL: define {{[^@]+}}@zed
; IS__CGSCC_OPM-SAME: (%pair* noalias nocapture noundef nonnull readonly byval([[PAIR:%.*]]) dereferenceable(8) [[DATA:%.*]]) {
; IS__CGSCC_OPM-NEXT:    call void @bar(%pair* noalias nocapture noundef nonnull readonly byval([[PAIR]]) dereferenceable(8) [[DATA]])
; IS__CGSCC_OPM-NEXT:    ret void
;
; IS__CGSCC_NPM-LABEL: define {{[^@]+}}@zed
; IS__CGSCC_NPM-SAME: (%pair* noalias nocapture nofree nonnull readonly byval([[PAIR:%.*]]) dereferenceable(8) [[DATA:%.*]]) {
; IS__CGSCC_NPM-NEXT:    [[DATA_CAST:%.*]] = bitcast %pair* [[DATA]] to i32*
; IS__CGSCC_NPM-NEXT:    [[TMP1:%.*]] = load i32, i32* [[DATA_CAST]], align 1
; IS__CGSCC_NPM-NEXT:    [[DATA_0_1:%.*]] = getelementptr [[PAIR]], %pair* [[DATA]], i32 0, i32 1
; IS__CGSCC_NPM-NEXT:    [[TMP2:%.*]] = load i32, i32* [[DATA_0_1]], align 1
; IS__CGSCC_NPM-NEXT:    call void @bar(i32 [[TMP1]], i32 [[TMP2]])
; IS__CGSCC_NPM-NEXT:    ret void
;
  call void @bar(%pair* byval(%pair) %Data)
  ret void
}
