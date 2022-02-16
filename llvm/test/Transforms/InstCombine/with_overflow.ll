; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -instcombine -S < %s | FileCheck %s

declare { i8, i1 } @llvm.uadd.with.overflow.i8(i8, i8) nounwind readnone
declare { i8, i1 } @llvm.sadd.with.overflow.i8(i8, i8) nounwind readnone
declare { i8, i1 } @llvm.usub.with.overflow.i8(i8, i8) nounwind readnone
declare { i8, i1 } @llvm.ssub.with.overflow.i8(i8, i8) nounwind readnone
declare { i8, i1 } @llvm.umul.with.overflow.i8(i8, i8) nounwind readnone
declare { i8, i1 } @llvm.smul.with.overflow.i8(i8, i8) nounwind readnone
declare { i32, i1 } @llvm.sadd.with.overflow.i32(i32, i32) nounwind readnone
declare { i32, i1 } @llvm.uadd.with.overflow.i32(i32, i32) nounwind readnone
declare { i32, i1 } @llvm.ssub.with.overflow.i32(i32, i32) nounwind readnone
declare { i32, i1 } @llvm.usub.with.overflow.i32(i32, i32) nounwind readnone
declare { i32, i1 } @llvm.smul.with.overflow.i32(i32, i32) nounwind readnone
declare { i32, i1 } @llvm.umul.with.overflow.i32(i32, i32) nounwind readnone

define i8 @uaddtest1(i8 %A, i8 %B) {
; CHECK-LABEL: @uaddtest1(
; CHECK-NEXT:    [[Y:%.*]] = add i8 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    ret i8 [[Y]]
;
  %x = call { i8, i1 } @llvm.uadd.with.overflow.i8(i8 %A, i8 %B)
  %y = extractvalue { i8, i1 } %x, 0
  ret i8 %y
}

define i8 @uaddtest2(i8 %A, i8 %B, i1* %overflowPtr) {
; CHECK-LABEL: @uaddtest2(
; CHECK-NEXT:    [[AND_A:%.*]] = and i8 [[A:%.*]], 127
; CHECK-NEXT:    [[AND_B:%.*]] = and i8 [[B:%.*]], 127
; CHECK-NEXT:    [[X:%.*]] = add nuw i8 [[AND_A]], [[AND_B]]
; CHECK-NEXT:    store i1 false, i1* [[OVERFLOWPTR:%.*]], align 1
; CHECK-NEXT:    ret i8 [[X]]
;
  %and.A = and i8 %A, 127
  %and.B = and i8 %B, 127
  %x = call { i8, i1 } @llvm.uadd.with.overflow.i8(i8 %and.A, i8 %and.B)
  %y = extractvalue { i8, i1 } %x, 0
  %z = extractvalue { i8, i1 } %x, 1
  store i1 %z, i1* %overflowPtr
  ret i8 %y
}

define i8 @uaddtest3(i8 %A, i8 %B, i1* %overflowPtr) {
; CHECK-LABEL: @uaddtest3(
; CHECK-NEXT:    [[OR_A:%.*]] = or i8 [[A:%.*]], -128
; CHECK-NEXT:    [[OR_B:%.*]] = or i8 [[B:%.*]], -128
; CHECK-NEXT:    [[X:%.*]] = add i8 [[OR_A]], [[OR_B]]
; CHECK-NEXT:    store i1 true, i1* [[OVERFLOWPTR:%.*]], align 1
; CHECK-NEXT:    ret i8 [[X]]
;
  %or.A = or i8 %A, -128
  %or.B = or i8 %B, -128
  %x = call { i8, i1 } @llvm.uadd.with.overflow.i8(i8 %or.A, i8 %or.B)
  %y = extractvalue { i8, i1 } %x, 0
  %z = extractvalue { i8, i1 } %x, 1
  store i1 %z, i1* %overflowPtr
  ret i8 %y
}

define i8 @uaddtest4(i8 %A, i1* %overflowPtr) {
; CHECK-LABEL: @uaddtest4(
; CHECK-NEXT:    store i1 false, i1* [[OVERFLOWPTR:%.*]], align 1
; CHECK-NEXT:    ret i8 -1
;
  %x = call { i8, i1 } @llvm.uadd.with.overflow.i8(i8 undef, i8 %A)
  %y = extractvalue { i8, i1 } %x, 0
  %z = extractvalue { i8, i1 } %x, 1
  store i1 %z, i1* %overflowPtr
  ret i8 %y
}

define i8 @uaddtest5(i8 %A, i1* %overflowPtr) {
; CHECK-LABEL: @uaddtest5(
; CHECK-NEXT:    store i1 false, i1* [[OVERFLOWPTR:%.*]], align 1
; CHECK-NEXT:    ret i8 [[A:%.*]]
;
  %x = call { i8, i1 } @llvm.uadd.with.overflow.i8(i8 0, i8 %A)
  %y = extractvalue { i8, i1 } %x, 0
  %z = extractvalue { i8, i1 } %x, 1
  store i1 %z, i1* %overflowPtr
  ret i8 %y
}

define i1 @uaddtest6(i8 %A, i8 %B) {
; CHECK-LABEL: @uaddtest6(
; CHECK-NEXT:    [[Z:%.*]] = icmp ugt i8 [[A:%.*]], 3
; CHECK-NEXT:    ret i1 [[Z]]
;
  %x = call { i8, i1 } @llvm.uadd.with.overflow.i8(i8 %A, i8 -4)
  %z = extractvalue { i8, i1 } %x, 1
  ret i1 %z
}

define i8 @uaddtest7(i8 %A, i8 %B) {
; CHECK-LABEL: @uaddtest7(
; CHECK-NEXT:    [[Z:%.*]] = add i8 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    ret i8 [[Z]]
;
  %x = call { i8, i1 } @llvm.uadd.with.overflow.i8(i8 %A, i8 %B)
  %z = extractvalue { i8, i1 } %x, 0
  ret i8 %z
}

; PR20194
define { i32, i1 } @saddtest_nsw(i8 %a, i8 %b) {
; CHECK-LABEL: @saddtest_nsw(
; CHECK-NEXT:    [[AA:%.*]] = sext i8 [[A:%.*]] to i32
; CHECK-NEXT:    [[BB:%.*]] = sext i8 [[B:%.*]] to i32
; CHECK-NEXT:    [[X:%.*]] = add nsw i32 [[AA]], [[BB]]
; CHECK-NEXT:    [[TMP1:%.*]] = insertvalue { i32, i1 } { i32 undef, i1 false }, i32 [[X]], 0
; CHECK-NEXT:    ret { i32, i1 } [[TMP1]]
;
  %aa = sext i8 %a to i32
  %bb = sext i8 %b to i32
  %x = call { i32, i1 } @llvm.sadd.with.overflow.i32(i32 %aa, i32 %bb)
  ret { i32, i1 } %x
}

define { i32, i1 } @uaddtest_nuw(i32 %a, i32 %b) {
; CHECK-LABEL: @uaddtest_nuw(
; CHECK-NEXT:    [[AA:%.*]] = and i32 [[A:%.*]], 2147483647
; CHECK-NEXT:    [[BB:%.*]] = and i32 [[B:%.*]], 2147483647
; CHECK-NEXT:    [[X:%.*]] = add nuw i32 [[AA]], [[BB]]
; CHECK-NEXT:    [[TMP1:%.*]] = insertvalue { i32, i1 } { i32 undef, i1 false }, i32 [[X]], 0
; CHECK-NEXT:    ret { i32, i1 } [[TMP1]]
;
  %aa = and i32 %a, 2147483647
  %bb = and i32 %b, 2147483647
  %x = call { i32, i1 } @llvm.uadd.with.overflow.i32(i32 %aa, i32 %bb)
  ret { i32, i1 } %x
}

define { i32, i1 } @ssubtest_nsw(i8 %a, i8 %b) {
; CHECK-LABEL: @ssubtest_nsw(
; CHECK-NEXT:    [[AA:%.*]] = sext i8 [[A:%.*]] to i32
; CHECK-NEXT:    [[BB:%.*]] = sext i8 [[B:%.*]] to i32
; CHECK-NEXT:    [[X:%.*]] = sub nsw i32 [[AA]], [[BB]]
; CHECK-NEXT:    [[TMP1:%.*]] = insertvalue { i32, i1 } { i32 undef, i1 false }, i32 [[X]], 0
; CHECK-NEXT:    ret { i32, i1 } [[TMP1]]
;
  %aa = sext i8 %a to i32
  %bb = sext i8 %b to i32
  %x = call { i32, i1 } @llvm.ssub.with.overflow.i32(i32 %aa, i32 %bb)
  ret { i32, i1 } %x
}

define { i32, i1 } @usubtest_nuw(i32 %a, i32 %b) {
; CHECK-LABEL: @usubtest_nuw(
; CHECK-NEXT:    [[AA:%.*]] = or i32 [[A:%.*]], -2147483648
; CHECK-NEXT:    [[BB:%.*]] = and i32 [[B:%.*]], 2147483647
; CHECK-NEXT:    [[X:%.*]] = sub nuw i32 [[AA]], [[BB]]
; CHECK-NEXT:    [[TMP1:%.*]] = insertvalue { i32, i1 } { i32 undef, i1 false }, i32 [[X]], 0
; CHECK-NEXT:    ret { i32, i1 } [[TMP1]]
;
  %aa = or i32 %a, 2147483648
  %bb = and i32 %b, 2147483647
  %x = call { i32, i1 } @llvm.usub.with.overflow.i32(i32 %aa, i32 %bb)
  ret { i32, i1 } %x
}

define { i32, i1 } @smultest1_nsw(i32 %a, i32 %b) {
; CHECK-LABEL: @smultest1_nsw(
; CHECK-NEXT:    [[AA:%.*]] = and i32 [[A:%.*]], 4095
; CHECK-NEXT:    [[BB:%.*]] = and i32 [[B:%.*]], 524287
; CHECK-NEXT:    [[X:%.*]] = mul nuw nsw i32 [[AA]], [[BB]]
; CHECK-NEXT:    [[TMP1:%.*]] = insertvalue { i32, i1 } { i32 undef, i1 false }, i32 [[X]], 0
; CHECK-NEXT:    ret { i32, i1 } [[TMP1]]
;
  %aa = and i32 %a, 4095 ; 0xfff
  %bb = and i32 %b, 524287; 0x7ffff
  %x = call { i32, i1 } @llvm.smul.with.overflow.i32(i32 %aa, i32 %bb)
  ret { i32, i1 } %x
}

define { i32, i1 } @smultest2_nsw(i32 %a, i32 %b) {
; CHECK-LABEL: @smultest2_nsw(
; CHECK-NEXT:    [[AA:%.*]] = ashr i32 [[A:%.*]], 16
; CHECK-NEXT:    [[BB:%.*]] = ashr i32 [[B:%.*]], 16
; CHECK-NEXT:    [[X:%.*]] = mul nsw i32 [[AA]], [[BB]]
; CHECK-NEXT:    [[TMP1:%.*]] = insertvalue { i32, i1 } { i32 undef, i1 false }, i32 [[X]], 0
; CHECK-NEXT:    ret { i32, i1 } [[TMP1]]
;
  %aa = ashr i32 %a, 16
  %bb = ashr i32 %b, 16
  %x = call { i32, i1 } @llvm.smul.with.overflow.i32(i32 %aa, i32 %bb)
  ret { i32, i1 } %x
}

define { i32, i1 } @smultest3_sw(i32 %a, i32 %b) {
; CHECK-LABEL: @smultest3_sw(
; CHECK-NEXT:    [[AA:%.*]] = ashr i32 [[A:%.*]], 16
; CHECK-NEXT:    [[BB:%.*]] = ashr i32 [[B:%.*]], 15
; CHECK-NEXT:    [[X:%.*]] = call { i32, i1 } @llvm.smul.with.overflow.i32(i32 [[AA]], i32 [[BB]])
; CHECK-NEXT:    ret { i32, i1 } [[X]]
;
  %aa = ashr i32 %a, 16
  %bb = ashr i32 %b, 15
  %x = call { i32, i1 } @llvm.smul.with.overflow.i32(i32 %aa, i32 %bb)
  ret { i32, i1 } %x
}

define { i32, i1 } @umultest_nuw(i32 %a, i32 %b) {
; CHECK-LABEL: @umultest_nuw(
; CHECK-NEXT:    [[AA:%.*]] = and i32 [[A:%.*]], 65535
; CHECK-NEXT:    [[BB:%.*]] = and i32 [[B:%.*]], 65535
; CHECK-NEXT:    [[X:%.*]] = mul nuw i32 [[AA]], [[BB]]
; CHECK-NEXT:    [[TMP1:%.*]] = insertvalue { i32, i1 } { i32 undef, i1 false }, i32 [[X]], 0
; CHECK-NEXT:    ret { i32, i1 } [[TMP1]]
;
  %aa = and i32 %a, 65535 ; 0xffff
  %bb = and i32 %b, 65535 ; 0xffff
  %x = call { i32, i1 } @llvm.umul.with.overflow.i32(i32 %aa, i32 %bb)
  ret { i32, i1 } %x
}

define i8 @umultest1(i8 %A, i1* %overflowPtr) {
; CHECK-LABEL: @umultest1(
; CHECK-NEXT:    store i1 false, i1* [[OVERFLOWPTR:%.*]], align 1
; CHECK-NEXT:    ret i8 0
;
  %x = call { i8, i1 } @llvm.umul.with.overflow.i8(i8 0, i8 %A)
  %y = extractvalue { i8, i1 } %x, 0
  %z = extractvalue { i8, i1 } %x, 1
  store i1 %z, i1* %overflowPtr
  ret i8 %y
}

define i8 @umultest2(i8 %A, i1* %overflowPtr) {
; CHECK-LABEL: @umultest2(
; CHECK-NEXT:    store i1 false, i1* [[OVERFLOWPTR:%.*]], align 1
; CHECK-NEXT:    ret i8 [[A:%.*]]
;
  %x = call { i8, i1 } @llvm.umul.with.overflow.i8(i8 1, i8 %A)
  %y = extractvalue { i8, i1 } %x, 0
  %z = extractvalue { i8, i1 } %x, 1
  store i1 %z, i1* %overflowPtr
  ret i8 %y
}

define i32 @umultest3(i32 %n) nounwind {
; CHECK-LABEL: @umultest3(
; CHECK-NEXT:    [[SHR:%.*]] = lshr i32 [[N:%.*]], 2
; CHECK-NEXT:    [[MUL:%.*]] = mul nuw i32 [[SHR]], 3
; CHECK-NEXT:    ret i32 [[MUL]]
;
  %shr = lshr i32 %n, 2
  %mul = call { i32, i1 } @llvm.umul.with.overflow.i32(i32 %shr, i32 3)
  %ov = extractvalue { i32, i1 } %mul, 1
  %res = extractvalue { i32, i1 } %mul, 0
  %ret = select i1 %ov, i32 -1, i32 %res
  ret i32 %ret
}

define i32 @umultest4(i32 %n) nounwind {
; CHECK-LABEL: @umultest4(
; CHECK-NEXT:    [[SHR:%.*]] = lshr i32 [[N:%.*]], 1
; CHECK-NEXT:    [[MUL:%.*]] = call { i32, i1 } @llvm.umul.with.overflow.i32(i32 [[SHR]], i32 4)
; CHECK-NEXT:    [[OV:%.*]] = extractvalue { i32, i1 } [[MUL]], 1
; CHECK-NEXT:    [[RES:%.*]] = extractvalue { i32, i1 } [[MUL]], 0
; CHECK-NEXT:    [[RET:%.*]] = select i1 [[OV]], i32 -1, i32 [[RES]]
; CHECK-NEXT:    ret i32 [[RET]]
;
  %shr = lshr i32 %n, 1
  %mul = call { i32, i1 } @llvm.umul.with.overflow.i32(i32 %shr, i32 4)
  %ov = extractvalue { i32, i1 } %mul, 1
  %res = extractvalue { i32, i1 } %mul, 0
  %ret = select i1 %ov, i32 -1, i32 %res
  ret i32 %ret
}

define { i32, i1 } @umultest5(i32 %x, i32 %y) nounwind {
; CHECK-LABEL: @umultest5(
; CHECK-NEXT:    [[OR_X:%.*]] = or i32 [[X:%.*]], -2147483648
; CHECK-NEXT:    [[OR_Y:%.*]] = or i32 [[Y:%.*]], -2147483648
; CHECK-NEXT:    [[MUL:%.*]] = mul i32 [[OR_X]], [[OR_Y]]
; CHECK-NEXT:    [[TMP1:%.*]] = insertvalue { i32, i1 } { i32 undef, i1 true }, i32 [[MUL]], 0
; CHECK-NEXT:    ret { i32, i1 } [[TMP1]]
;
  %or_x = or i32 %x, 2147483648
  %or_y = or i32 %y, 2147483648
  %mul = call { i32, i1 } @llvm.umul.with.overflow.i32(i32 %or_x, i32 %or_y)
  ret { i32, i1 } %mul
}

define i1 @overflow_div_add(i32 %v1, i32 %v2) nounwind {
; CHECK-LABEL: @overflow_div_add(
; CHECK-NEXT:    ret i1 false
;
  %div = sdiv i32 %v1, 2
  %t = call { i32, i1 } @llvm.sadd.with.overflow.i32(i32 %div, i32 1)
  %obit = extractvalue { i32, i1 } %t, 1
  ret i1 %obit
}

define i1 @overflow_div_sub(i32 %v1, i32 %v2) nounwind {
  ; Check cases where the known sign bits are larger than the word size.
; CHECK-LABEL: @overflow_div_sub(
; CHECK-NEXT:    ret i1 false
;
  %a = ashr i32 %v1, 18
  %div = sdiv i32 %a, 65536
  %t = call { i32, i1 } @llvm.ssub.with.overflow.i32(i32 %div, i32 1)
  %obit = extractvalue { i32, i1 } %t, 1
  ret i1 %obit
}

define i1 @overflow_mod_mul(i32 %v1, i32 %v2) nounwind {
; CHECK-LABEL: @overflow_mod_mul(
; CHECK-NEXT:    ret i1 false
;
  %rem = srem i32 %v1, 1000
  %t = call { i32, i1 } @llvm.smul.with.overflow.i32(i32 %rem, i32 %rem)
  %obit = extractvalue { i32, i1 } %t, 1
  ret i1 %obit
}

define i1 @overflow_mod_overflow_mul(i32 %v1, i32 %v2) nounwind {
; CHECK-LABEL: @overflow_mod_overflow_mul(
; CHECK-NEXT:    [[REM:%.*]] = srem i32 [[V1:%.*]], 65537
; CHECK-NEXT:    [[T:%.*]] = call { i32, i1 } @llvm.smul.with.overflow.i32(i32 [[REM]], i32 [[REM]])
; CHECK-NEXT:    [[OBIT:%.*]] = extractvalue { i32, i1 } [[T]], 1
; CHECK-NEXT:    ret i1 [[OBIT]]
;
  %rem = srem i32 %v1, 65537
  ; This may overflow because the result of the mul operands may be greater than 16bits
  ; and the result greater than 32.
  %t = call { i32, i1 } @llvm.smul.with.overflow.i32(i32 %rem, i32 %rem)
  %obit = extractvalue { i32, i1 } %t, 1
  ret i1 %obit
}

define i1 @overflow_mod_mul2(i16 %v1, i32 %v2) nounwind {
; CHECK-LABEL: @overflow_mod_mul2(
; CHECK-NEXT:    ret i1 false
;
  %a = sext i16 %v1 to i32
  %rem = srem i32 %a, %v2
  %t = call { i32, i1 } @llvm.smul.with.overflow.i32(i32 %rem, i32 %rem)
  %obit = extractvalue { i32, i1 } %t, 1
  ret i1 %obit
}

define { i32, i1 } @ssubtest_reorder(i8 %a) {
; CHECK-LABEL: @ssubtest_reorder(
; CHECK-NEXT:    [[AA:%.*]] = sext i8 [[A:%.*]] to i32
; CHECK-NEXT:    [[X:%.*]] = sub nsw i32 0, [[AA]]
; CHECK-NEXT:    [[TMP1:%.*]] = insertvalue { i32, i1 } { i32 undef, i1 false }, i32 [[X]], 0
; CHECK-NEXT:    ret { i32, i1 } [[TMP1]]
;
  %aa = sext i8 %a to i32
  %x = call { i32, i1 } @llvm.ssub.with.overflow.i32(i32 0, i32 %aa)
  ret { i32, i1 } %x
}

define { i32, i1 } @never_overflows_ssub_test0(i32 %a) {
; CHECK-LABEL: @never_overflows_ssub_test0(
; CHECK-NEXT:    [[X:%.*]] = insertvalue { i32, i1 } { i32 undef, i1 false }, i32 [[A:%.*]], 0
; CHECK-NEXT:    ret { i32, i1 } [[X]]
;
  %x = call { i32, i1 } @llvm.ssub.with.overflow.i32(i32 %a, i32 0)
  ret { i32, i1 } %x
}

define i1 @uadd_res_ult_x(i32 %x, i32 %y, i1* %p) nounwind {
; CHECK-LABEL: @uadd_res_ult_x(
; CHECK-NEXT:    [[A:%.*]] = call { i32, i1 } @llvm.uadd.with.overflow.i32(i32 [[X:%.*]], i32 [[Y:%.*]])
; CHECK-NEXT:    [[B:%.*]] = extractvalue { i32, i1 } [[A]], 1
; CHECK-NEXT:    store i1 [[B]], i1* [[P:%.*]], align 1
; CHECK-NEXT:    [[D:%.*]] = extractvalue { i32, i1 } [[A]], 1
; CHECK-NEXT:    ret i1 [[D]]
;
  %a = call { i32, i1 } @llvm.uadd.with.overflow.i32(i32 %x, i32 %y)
  %b = extractvalue { i32, i1 } %a, 1
  store i1 %b, i1* %p
  %c = extractvalue { i32, i1 } %a, 0
  %d = icmp ult i32 %c, %x
  ret i1 %d
}

define i1 @uadd_res_ult_y(i32 %x, i32 %y, i1* %p) nounwind {
; CHECK-LABEL: @uadd_res_ult_y(
; CHECK-NEXT:    [[A:%.*]] = call { i32, i1 } @llvm.uadd.with.overflow.i32(i32 [[X:%.*]], i32 [[Y:%.*]])
; CHECK-NEXT:    [[B:%.*]] = extractvalue { i32, i1 } [[A]], 1
; CHECK-NEXT:    store i1 [[B]], i1* [[P:%.*]], align 1
; CHECK-NEXT:    [[D:%.*]] = extractvalue { i32, i1 } [[A]], 1
; CHECK-NEXT:    ret i1 [[D]]
;
  %a = call { i32, i1 } @llvm.uadd.with.overflow.i32(i32 %x, i32 %y)
  %b = extractvalue { i32, i1 } %a, 1
  store i1 %b, i1* %p
  %c = extractvalue { i32, i1 } %a, 0
  %d = icmp ult i32 %c, %y
  ret i1 %d
}

define i1 @uadd_res_ugt_x(i32 %xx, i32 %y, i1* %p) nounwind {
; CHECK-LABEL: @uadd_res_ugt_x(
; CHECK-NEXT:    [[X:%.*]] = urem i32 42, [[XX:%.*]]
; CHECK-NEXT:    [[A:%.*]] = call { i32, i1 } @llvm.uadd.with.overflow.i32(i32 [[X]], i32 [[Y:%.*]])
; CHECK-NEXT:    [[B:%.*]] = extractvalue { i32, i1 } [[A]], 1
; CHECK-NEXT:    store i1 [[B]], i1* [[P:%.*]], align 1
; CHECK-NEXT:    [[D:%.*]] = extractvalue { i32, i1 } [[A]], 1
; CHECK-NEXT:    ret i1 [[D]]
;
  %x = urem i32 42, %xx ; Thwart complexity-based canonicalization
  %a = call { i32, i1 } @llvm.uadd.with.overflow.i32(i32 %x, i32 %y)
  %b = extractvalue { i32, i1 } %a, 1
  store i1 %b, i1* %p
  %c = extractvalue { i32, i1 } %a, 0
  %d = icmp ugt i32 %x, %c
  ret i1 %d
}

define i1 @uadd_res_ugt_y(i32 %x, i32 %yy, i1* %p) nounwind {
; CHECK-LABEL: @uadd_res_ugt_y(
; CHECK-NEXT:    [[Y:%.*]] = urem i32 42, [[YY:%.*]]
; CHECK-NEXT:    [[A:%.*]] = call { i32, i1 } @llvm.uadd.with.overflow.i32(i32 [[X:%.*]], i32 [[Y]])
; CHECK-NEXT:    [[B:%.*]] = extractvalue { i32, i1 } [[A]], 1
; CHECK-NEXT:    store i1 [[B]], i1* [[P:%.*]], align 1
; CHECK-NEXT:    [[D:%.*]] = extractvalue { i32, i1 } [[A]], 1
; CHECK-NEXT:    ret i1 [[D]]
;
  %y = urem i32 42, %yy ; Thwart complexity-based canonicalization
  %a = call { i32, i1 } @llvm.uadd.with.overflow.i32(i32 %x, i32 %y)
  %b = extractvalue { i32, i1 } %a, 1
  store i1 %b, i1* %p
  %c = extractvalue { i32, i1 } %a, 0
  %d = icmp ugt i32 %y, %c
  ret i1 %d
}

define i1 @uadd_res_ult_const(i32 %x, i1* %p) nounwind {
; CHECK-LABEL: @uadd_res_ult_const(
; CHECK-NEXT:    [[A:%.*]] = call { i32, i1 } @llvm.uadd.with.overflow.i32(i32 [[X:%.*]], i32 42)
; CHECK-NEXT:    [[B:%.*]] = extractvalue { i32, i1 } [[A]], 1
; CHECK-NEXT:    store i1 [[B]], i1* [[P:%.*]], align 1
; CHECK-NEXT:    [[D:%.*]] = extractvalue { i32, i1 } [[A]], 1
; CHECK-NEXT:    ret i1 [[D]]
;
  %a = call { i32, i1 } @llvm.uadd.with.overflow.i32(i32 %x, i32 42)
  %b = extractvalue { i32, i1 } %a, 1
  store i1 %b, i1* %p
  %c = extractvalue { i32, i1 } %a, 0
  %d = icmp ult i32 %c, 42
  ret i1 %d
}

define i1 @uadd_res_ult_const_one(i32 %x, i1* %p) nounwind {
; CHECK-LABEL: @uadd_res_ult_const_one(
; CHECK-NEXT:    [[A:%.*]] = call { i32, i1 } @llvm.uadd.with.overflow.i32(i32 [[X:%.*]], i32 1)
; CHECK-NEXT:    [[B:%.*]] = extractvalue { i32, i1 } [[A]], 1
; CHECK-NEXT:    store i1 [[B]], i1* [[P:%.*]], align 1
; CHECK-NEXT:    [[D:%.*]] = extractvalue { i32, i1 } [[A]], 1
; CHECK-NEXT:    ret i1 [[D]]
;
  %a = call { i32, i1 } @llvm.uadd.with.overflow.i32(i32 %x, i32 1)
  %b = extractvalue { i32, i1 } %a, 1
  store i1 %b, i1* %p
  %c = extractvalue { i32, i1 } %a, 0
  %d = icmp ult i32 %c, 1
  ret i1 %d
}

define i1 @uadd_res_ult_const_minus_one(i32 %x, i1* %p) nounwind {
; CHECK-LABEL: @uadd_res_ult_const_minus_one(
; CHECK-NEXT:    [[A:%.*]] = call { i32, i1 } @llvm.uadd.with.overflow.i32(i32 [[X:%.*]], i32 -1)
; CHECK-NEXT:    [[B:%.*]] = extractvalue { i32, i1 } [[A]], 1
; CHECK-NEXT:    store i1 [[B]], i1* [[P:%.*]], align 1
; CHECK-NEXT:    [[D:%.*]] = extractvalue { i32, i1 } [[A]], 1
; CHECK-NEXT:    ret i1 [[D]]
;
  %a = call { i32, i1 } @llvm.uadd.with.overflow.i32(i32 %x, i32 -1)
  %b = extractvalue { i32, i1 } %a, 1
  store i1 %b, i1* %p
  %c = extractvalue { i32, i1 } %a, 0
  %d = icmp ult i32 %c, -1
  ret i1 %d
}

define { i32, i1 } @sadd_canonicalize_constant_arg0(i32 %x) nounwind {
; CHECK-LABEL: @sadd_canonicalize_constant_arg0(
; CHECK-NEXT:    [[A:%.*]] = call { i32, i1 } @llvm.sadd.with.overflow.i32(i32 [[X:%.*]], i32 42)
; CHECK-NEXT:    ret { i32, i1 } [[A]]
;
  %a = call { i32, i1 } @llvm.sadd.with.overflow.i32(i32 42, i32 %x)
  ret { i32, i1 } %a
}

define { i32, i1 } @uadd_canonicalize_constant_arg0(i32 %x) nounwind {
; CHECK-LABEL: @uadd_canonicalize_constant_arg0(
; CHECK-NEXT:    [[A:%.*]] = call { i32, i1 } @llvm.uadd.with.overflow.i32(i32 [[X:%.*]], i32 42)
; CHECK-NEXT:    ret { i32, i1 } [[A]]
;
  %a = call { i32, i1 } @llvm.uadd.with.overflow.i32(i32 42, i32 %x)
  ret { i32, i1 } %a
}

define { i32, i1 } @ssub_no_canonicalize_constant_arg0(i32 %x) nounwind {
; CHECK-LABEL: @ssub_no_canonicalize_constant_arg0(
; CHECK-NEXT:    [[A:%.*]] = call { i32, i1 } @llvm.ssub.with.overflow.i32(i32 42, i32 [[X:%.*]])
; CHECK-NEXT:    ret { i32, i1 } [[A]]
;
  %a = call { i32, i1 } @llvm.ssub.with.overflow.i32(i32 42, i32 %x)
  ret { i32, i1 } %a
}

define { i32, i1 } @usub_no_canonicalize_constant_arg0(i32 %x) nounwind {
; CHECK-LABEL: @usub_no_canonicalize_constant_arg0(
; CHECK-NEXT:    [[A:%.*]] = call { i32, i1 } @llvm.usub.with.overflow.i32(i32 42, i32 [[X:%.*]])
; CHECK-NEXT:    ret { i32, i1 } [[A]]
;
  %a = call { i32, i1 } @llvm.usub.with.overflow.i32(i32 42, i32 %x)
  ret { i32, i1 } %a
}

define { i32, i1 } @smul_canonicalize_constant_arg0(i32 %x) nounwind {
; CHECK-LABEL: @smul_canonicalize_constant_arg0(
; CHECK-NEXT:    [[A:%.*]] = call { i32, i1 } @llvm.smul.with.overflow.i32(i32 [[X:%.*]], i32 42)
; CHECK-NEXT:    ret { i32, i1 } [[A]]
;
  %a = call { i32, i1 } @llvm.smul.with.overflow.i32(i32 42, i32 %x)
  ret { i32, i1 } %a
}

define { i32, i1 } @umul_canonicalize_constant_arg0(i32 %x) nounwind {
; CHECK-LABEL: @umul_canonicalize_constant_arg0(
; CHECK-NEXT:    [[A:%.*]] = call { i32, i1 } @llvm.umul.with.overflow.i32(i32 [[X:%.*]], i32 42)
; CHECK-NEXT:    ret { i32, i1 } [[A]]
;
  %a = call { i32, i1 } @llvm.umul.with.overflow.i32(i32 42, i32 %x)
  ret { i32, i1 } %a
}

; Always overflow tests

define { i8, i1 } @uadd_always_overflow(i8 %x) nounwind {
; CHECK-LABEL: @uadd_always_overflow(
; CHECK-NEXT:    [[TMP1:%.*]] = and i8 [[X:%.*]], 63
; CHECK-NEXT:    [[TMP2:%.*]] = insertvalue { i8, i1 } { i8 undef, i1 true }, i8 [[TMP1]], 0
; CHECK-NEXT:    ret { i8, i1 } [[TMP2]]
;
  %y = or i8 %x, 192
  %a = call { i8, i1 } @llvm.uadd.with.overflow.i8(i8 %y, i8 64)
  ret { i8, i1 } %a
}

define { i8, i1 } @usub_always_overflow(i8 %x) nounwind {
; CHECK-LABEL: @usub_always_overflow(
; CHECK-NEXT:    [[Y:%.*]] = or i8 [[X:%.*]], 64
; CHECK-NEXT:    [[A:%.*]] = sub nsw i8 63, [[Y]]
; CHECK-NEXT:    [[TMP1:%.*]] = insertvalue { i8, i1 } { i8 undef, i1 true }, i8 [[A]], 0
; CHECK-NEXT:    ret { i8, i1 } [[TMP1]]
;
  %y = or i8 %x, 64
  %a = call { i8, i1 } @llvm.usub.with.overflow.i8(i8 63, i8 %y)
  ret { i8, i1 } %a
}

define { i8, i1 } @umul_always_overflow(i8 %x) nounwind {
; CHECK-LABEL: @umul_always_overflow(
; CHECK-NEXT:    [[A:%.*]] = shl i8 [[X:%.*]], 1
; CHECK-NEXT:    [[TMP1:%.*]] = insertvalue { i8, i1 } { i8 undef, i1 true }, i8 [[A]], 0
; CHECK-NEXT:    ret { i8, i1 } [[TMP1]]
;
  %y = or i8 %x, 128
  %a = call { i8, i1 } @llvm.umul.with.overflow.i8(i8 %y, i8 2)
  ret { i8, i1 } %a
}

define { i8, i1 } @sadd_always_overflow(i8 %x) nounwind {
; CHECK-LABEL: @sadd_always_overflow(
; CHECK-NEXT:    [[C:%.*]] = icmp sgt i8 [[X:%.*]], 100
; CHECK-NEXT:    [[Y:%.*]] = select i1 [[C]], i8 [[X]], i8 100
; CHECK-NEXT:    [[A:%.*]] = add nuw i8 [[Y]], 28
; CHECK-NEXT:    [[TMP1:%.*]] = insertvalue { i8, i1 } { i8 undef, i1 true }, i8 [[A]], 0
; CHECK-NEXT:    ret { i8, i1 } [[TMP1]]
;
  %c = icmp sgt i8 %x, 100
  %y = select i1 %c, i8 %x, i8 100
  %a = call { i8, i1 } @llvm.sadd.with.overflow.i8(i8 %y, i8 28)
  ret { i8, i1 } %a
}

define { i8, i1 } @ssub_always_overflow(i8 %x) nounwind {
; CHECK-LABEL: @ssub_always_overflow(
; CHECK-NEXT:    [[C:%.*]] = icmp sgt i8 [[X:%.*]], 29
; CHECK-NEXT:    [[Y:%.*]] = select i1 [[C]], i8 [[X]], i8 29
; CHECK-NEXT:    [[A:%.*]] = sub nuw i8 -100, [[Y]]
; CHECK-NEXT:    [[TMP1:%.*]] = insertvalue { i8, i1 } { i8 undef, i1 true }, i8 [[A]], 0
; CHECK-NEXT:    ret { i8, i1 } [[TMP1]]
;
  %c = icmp sgt i8 %x, 29
  %y = select i1 %c, i8 %x, i8 29
  %a = call { i8, i1 } @llvm.ssub.with.overflow.i8(i8 -100, i8 %y)
  ret { i8, i1 } %a
}

define { i8, i1 } @smul_always_overflow(i8 %x) nounwind {
; CHECK-LABEL: @smul_always_overflow(
; CHECK-NEXT:    [[C:%.*]] = icmp sgt i8 [[X:%.*]], 100
; CHECK-NEXT:    [[Y:%.*]] = select i1 [[C]], i8 [[X]], i8 100
; CHECK-NEXT:    [[A:%.*]] = call { i8, i1 } @llvm.smul.with.overflow.i8(i8 [[Y]], i8 2)
; CHECK-NEXT:    ret { i8, i1 } [[A]]
;
  %c = icmp sgt i8 %x, 100
  %y = select i1 %c, i8 %x, i8 100
  %a = call { i8, i1 } @llvm.smul.with.overflow.i8(i8 %y, i8 2)
  ret { i8, i1 } %a
}

declare { <4 x i8>, <4 x i1> } @llvm.sadd.with.overflow.v4i8(<4 x i8>, <4 x i8>)
declare { <4 x i8>, <4 x i1> } @llvm.uadd.with.overflow.v4i8(<4 x i8>, <4 x i8>)
declare { <4 x i8>, <4 x i1> } @llvm.ssub.with.overflow.v4i8(<4 x i8>, <4 x i8>)
declare { <4 x i8>, <4 x i1> } @llvm.usub.with.overflow.v4i8(<4 x i8>, <4 x i8>)
declare { <4 x i8>, <4 x i1> } @llvm.smul.with.overflow.v4i8(<4 x i8>, <4 x i8>)
declare { <4 x i8>, <4 x i1> } @llvm.umul.with.overflow.v4i8(<4 x i8>, <4 x i8>)

; Always overflow

define { <4 x i8>, <4 x i1> } @always_sadd_const_vector() nounwind {
; CHECK-LABEL: @always_sadd_const_vector(
; CHECK-NEXT:    ret { <4 x i8>, <4 x i1> } { <4 x i8> <i8 -128, i8 -128, i8 -128, i8 -128>, <4 x i1> <i1 true, i1 true, i1 true, i1 true> }
;
  %x = call { <4 x i8>, <4 x i1> } @llvm.sadd.with.overflow.v4i8(<4 x i8> <i8 127, i8 127, i8 127, i8 127>, <4 x i8> <i8 1, i8 1, i8 1, i8 1>)
  ret { <4 x i8>, <4 x i1> } %x
}

define { <4 x i8>, <4 x i1> } @always_uadd_const_vector() nounwind {
; CHECK-LABEL: @always_uadd_const_vector(
; CHECK-NEXT:    ret { <4 x i8>, <4 x i1> } { <4 x i8> zeroinitializer, <4 x i1> <i1 true, i1 true, i1 true, i1 true> }
;
  %x = call { <4 x i8>, <4 x i1> } @llvm.uadd.with.overflow.v4i8(<4 x i8> <i8 255, i8 255, i8 255, i8 255>, <4 x i8> <i8 1, i8 1, i8 1, i8 1>)
  ret { <4 x i8>, <4 x i1> } %x
}

define { <4 x i8>, <4 x i1> } @always_ssub_const_vector() nounwind {
; CHECK-LABEL: @always_ssub_const_vector(
; CHECK-NEXT:    ret { <4 x i8>, <4 x i1> } { <4 x i8> <i8 127, i8 127, i8 127, i8 127>, <4 x i1> <i1 true, i1 true, i1 true, i1 true> }
;
  %x = call { <4 x i8>, <4 x i1> } @llvm.ssub.with.overflow.v4i8(<4 x i8> <i8 -128, i8 -128, i8 -128, i8 -128>, <4 x i8> <i8 1, i8 1, i8 1, i8 1>)
  ret { <4 x i8>, <4 x i1> } %x
}

define { <4 x i8>, <4 x i1> } @always_usub_const_vector() nounwind {
; CHECK-LABEL: @always_usub_const_vector(
; CHECK-NEXT:    ret { <4 x i8>, <4 x i1> } { <4 x i8> <i8 -1, i8 -1, i8 -1, i8 -1>, <4 x i1> <i1 true, i1 true, i1 true, i1 true> }
;
  %x = call { <4 x i8>, <4 x i1> } @llvm.usub.with.overflow.v4i8(<4 x i8> <i8 0, i8 0, i8 0, i8 0>, <4 x i8> <i8 1, i8 1, i8 1, i8 1>)
  ret { <4 x i8>, <4 x i1> } %x
}

; NOTE: LLVM doesn't (yet) detect the multiplication always results in a overflow
define { <4 x i8>, <4 x i1> } @always_smul_const_vector() nounwind {
; CHECK-LABEL: @always_smul_const_vector(
; CHECK-NEXT:    [[X:%.*]] = call { <4 x i8>, <4 x i1> } @llvm.smul.with.overflow.v4i8(<4 x i8> <i8 127, i8 127, i8 127, i8 127>, <4 x i8> <i8 3, i8 3, i8 3, i8 3>)
; CHECK-NEXT:    ret { <4 x i8>, <4 x i1> } [[X]]
;
  %x = call { <4 x i8>, <4 x i1> } @llvm.smul.with.overflow.v4i8(<4 x i8> <i8 127, i8 127, i8 127, i8 127>, <4 x i8> <i8 3, i8 3, i8 3, i8 3>)
  ret { <4 x i8>, <4 x i1> } %x
}

define { <4 x i8>, <4 x i1> } @always_umul_const_vector() nounwind {
; CHECK-LABEL: @always_umul_const_vector(
; CHECK-NEXT:    ret { <4 x i8>, <4 x i1> } { <4 x i8> <i8 -3, i8 -3, i8 -3, i8 -3>, <4 x i1> <i1 true, i1 true, i1 true, i1 true> }
;
  %x = call { <4 x i8>, <4 x i1> } @llvm.umul.with.overflow.v4i8(<4 x i8> <i8 255, i8 255, i8 255, i8 255>, <4 x i8> <i8 3, i8 3, i8 3, i8 3>)
  ret { <4 x i8>, <4 x i1> } %x
}

; Never overflow

define { <4 x i8>, <4 x i1> } @never_sadd_const_vector() nounwind {
; CHECK-LABEL: @never_sadd_const_vector(
; CHECK-NEXT:    ret { <4 x i8>, <4 x i1> } { <4 x i8> <i8 -50, i8 -10, i8 0, i8 60>, <4 x i1> zeroinitializer }
;
  %x = call { <4 x i8>, <4 x i1> } @llvm.sadd.with.overflow.v4i8(<4 x i8> <i8 -10, i8 -20, i8 30, i8 40>, <4 x i8> <i8 -40, i8 10, i8 -30, i8 20>)
  ret { <4 x i8>, <4 x i1> } %x
}

define { <4 x i8>, <4 x i1> } @never_uadd_const_vector() nounwind {
; CHECK-LABEL: @never_uadd_const_vector(
; CHECK-NEXT:    ret { <4 x i8>, <4 x i1> } { <4 x i8> <i8 32, i8 64, i8 96, i8 48>, <4 x i1> zeroinitializer }
;
  %x = call { <4 x i8>, <4 x i1> } @llvm.uadd.with.overflow.v4i8(<4 x i8> <i8 0, i8 32, i8 64, i8 16>, <4 x i8> <i8 32, i8 32, i8 32, i8 32>)
  ret { <4 x i8>, <4 x i1> } %x
}

define { <4 x i8>, <4 x i1> } @never_ssub_const_vector() nounwind {
; CHECK-LABEL: @never_ssub_const_vector(
; CHECK-NEXT:    ret { <4 x i8>, <4 x i1> } { <4 x i8> <i8 0, i8 10, i8 20, i8 30>, <4 x i1> zeroinitializer }
;
  %x = call { <4 x i8>, <4 x i1> } @llvm.ssub.with.overflow.v4i8(<4 x i8> <i8 -10, i8 -10, i8 -10, i8 -10>, <4 x i8> <i8 -10, i8 -20, i8 -30, i8 -40>)
  ret { <4 x i8>, <4 x i1> } %x
}

define { <4 x i8>, <4 x i1> } @never_usub_const_vector() nounwind {
; CHECK-LABEL: @never_usub_const_vector(
; CHECK-NEXT:    ret { <4 x i8>, <4 x i1> } { <4 x i8> <i8 127, i8 -1, i8 0, i8 -2>, <4 x i1> zeroinitializer }
;
  %x = call { <4 x i8>, <4 x i1> } @llvm.usub.with.overflow.v4i8(<4 x i8> <i8 255, i8 255, i8 255, i8 255>, <4 x i8> <i8 128, i8 0, i8 255, i8 1>)
  ret { <4 x i8>, <4 x i1> } %x
}

define { <4 x i8>, <4 x i1> } @never_smul_const_vector() nounwind {
; CHECK-LABEL: @never_smul_const_vector(
; CHECK-NEXT:    ret { <4 x i8>, <4 x i1> } { <4 x i8> <i8 -54, i8 -18, i8 -60, i8 -90>, <4 x i1> zeroinitializer }
;
  %x = call { <4 x i8>, <4 x i1> } @llvm.smul.with.overflow.v4i8(<4 x i8> <i8 -6, i8 -6, i8 -6, i8 -6>, <4 x i8> <i8 9, i8 3, i8 10, i8 15>)
  ret { <4 x i8>, <4 x i1> } %x
}

define { <4 x i8>, <4 x i1> } @never_umul_const_vector() nounwind {
; CHECK-LABEL: @never_umul_const_vector(
; CHECK-NEXT:    ret { <4 x i8>, <4 x i1> } { <4 x i8> <i8 -31, i8 120, i8 60, i8 30>, <4 x i1> zeroinitializer }
;
  %x = call { <4 x i8>, <4 x i1> } @llvm.umul.with.overflow.v4i8(<4 x i8> <i8 15, i8 15, i8 15, i8 15>, <4 x i8> <i8 15, i8 8, i8 4, i8 2>)
  ret { <4 x i8>, <4 x i1> } %x
}

; Neutral value

define { <4 x i8>, <4 x i1> } @neutral_sadd_const_vector() nounwind {
; CHECK-LABEL: @neutral_sadd_const_vector(
; CHECK-NEXT:    ret { <4 x i8>, <4 x i1> } { <4 x i8> <i8 1, i8 2, i8 3, i8 4>, <4 x i1> zeroinitializer }
;
  %x = call { <4 x i8>, <4 x i1> } @llvm.sadd.with.overflow.v4i8(<4 x i8> <i8 1, i8 2, i8 3, i8 4>, <4 x i8> <i8 0, i8 0, i8 0, i8 0>)
  ret { <4 x i8>, <4 x i1> } %x
}

define { <4 x i8>, <4 x i1> } @neutral_uadd_const_vector() nounwind {
; CHECK-LABEL: @neutral_uadd_const_vector(
; CHECK-NEXT:    ret { <4 x i8>, <4 x i1> } { <4 x i8> <i8 1, i8 2, i8 3, i8 4>, <4 x i1> zeroinitializer }
;
  %x = call { <4 x i8>, <4 x i1> } @llvm.uadd.with.overflow.v4i8(<4 x i8> <i8 1, i8 2, i8 3, i8 4>, <4 x i8> <i8 0, i8 0, i8 0, i8 0>)
  ret { <4 x i8>, <4 x i1> } %x
}

define { <4 x i8>, <4 x i1> } @neutral_ssub_const_vector() nounwind {
; CHECK-LABEL: @neutral_ssub_const_vector(
; CHECK-NEXT:    ret { <4 x i8>, <4 x i1> } { <4 x i8> <i8 1, i8 2, i8 3, i8 4>, <4 x i1> zeroinitializer }
;
  %x = call { <4 x i8>, <4 x i1> } @llvm.ssub.with.overflow.v4i8(<4 x i8> <i8 1, i8 2, i8 3, i8 4>, <4 x i8> <i8 0, i8 0, i8 0, i8 0>)
  ret { <4 x i8>, <4 x i1> } %x
}

define { <4 x i8>, <4 x i1> } @neutral_usub_const_vector() nounwind {
; CHECK-LABEL: @neutral_usub_const_vector(
; CHECK-NEXT:    ret { <4 x i8>, <4 x i1> } { <4 x i8> <i8 1, i8 2, i8 3, i8 4>, <4 x i1> zeroinitializer }
;
  %x = call { <4 x i8>, <4 x i1> } @llvm.usub.with.overflow.v4i8(<4 x i8> <i8 1, i8 2, i8 3, i8 4>, <4 x i8> <i8 0, i8 0, i8 0, i8 0>)
  ret { <4 x i8>, <4 x i1> } %x
}

define { <4 x i8>, <4 x i1> } @neutral_smul_const_vector() nounwind {
; CHECK-LABEL: @neutral_smul_const_vector(
; CHECK-NEXT:    ret { <4 x i8>, <4 x i1> } { <4 x i8> <i8 1, i8 2, i8 3, i8 4>, <4 x i1> zeroinitializer }
;
  %x = call { <4 x i8>, <4 x i1> } @llvm.smul.with.overflow.v4i8(<4 x i8> <i8 1, i8 2, i8 3, i8 4>, <4 x i8> <i8 1, i8 1, i8 1, i8 1>)
  ret { <4 x i8>, <4 x i1> } %x
}

define { <4 x i8>, <4 x i1> } @neutral_umul_const_vector() nounwind {
; CHECK-LABEL: @neutral_umul_const_vector(
; CHECK-NEXT:    ret { <4 x i8>, <4 x i1> } { <4 x i8> <i8 1, i8 2, i8 3, i8 4>, <4 x i1> zeroinitializer }
;
  %x = call { <4 x i8>, <4 x i1> } @llvm.umul.with.overflow.v4i8(<4 x i8> <i8 1, i8 2, i8 3, i8 4>, <4 x i8> <i8 1, i8 1, i8 1, i8 1>)
  ret { <4 x i8>, <4 x i1> } %x
}
