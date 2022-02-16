; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instsimplify -S | FileCheck %s

declare i8 @llvm.abs.i8(i8, i1)
declare <8 x i8> @llvm.abs.v8i8(<8 x i8>, i1)

define i8 @undef_val_min_poison() {
; CHECK-LABEL: @undef_val_min_poison(
; CHECK-NEXT:    ret i8 undef
;
  %r = call i8 @llvm.abs.i8(i8 undef, i1 true)
  ret i8 %r
}

define i8 @undef_val_min_not_poison() {
; CHECK-LABEL: @undef_val_min_not_poison(
; CHECK-NEXT:    ret i8 0
;
  %r = call i8 @llvm.abs.i8(i8 undef, i1 false)
  ret i8 %r
}

define i8 @min_val_min_poison() {
; CHECK-LABEL: @min_val_min_poison(
; CHECK-NEXT:    ret i8 undef
;
  %r = call i8 @llvm.abs.i8(i8 -128, i1 true)
  ret i8 %r
}

define i8 @min_val_min_not_poison() {
; CHECK-LABEL: @min_val_min_not_poison(
; CHECK-NEXT:    ret i8 -128
;
  %r = call i8 @llvm.abs.i8(i8 -128, i1 false)
  ret i8 %r
}

define <8 x i8> @vec_const() {
; CHECK-LABEL: @vec_const(
; CHECK-NEXT:    ret <8 x i8> <i8 127, i8 126, i8 42, i8 1, i8 0, i8 1, i8 42, i8 127>
;
  %r = call <8 x i8> @llvm.abs.v8i8(<8 x i8> <i8 -127, i8 -126, i8 -42, i8 -1, i8 0, i8 1, i8 42, i8 127>, i1 1)
  ret <8 x i8> %r
}
