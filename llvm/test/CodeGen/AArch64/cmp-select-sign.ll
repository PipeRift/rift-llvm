; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=arm64-apple-iphoneos -o - %s | FileCheck %s

define i3 @sign_i3(i3 %a) {
; CHECK-LABEL: sign_i3:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sbfx w8, w0, #2, #1
; CHECK-NEXT:    orr w0, w8, #0x1
; CHECK-NEXT:    ret
  %c = icmp sgt i3 %a, -1
  %res = select i1 %c, i3 1, i3 -1
  ret i3 %res
}

define i4 @sign_i4(i4 %a) {
; CHECK-LABEL: sign_i4:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sbfx w8, w0, #3, #1
; CHECK-NEXT:    orr w0, w8, #0x1
; CHECK-NEXT:    ret
  %c = icmp sgt i4 %a, -1
  %res = select i1 %c, i4 1, i4 -1
  ret i4 %res
}

define i8 @sign_i8(i8 %a) {
; CHECK-LABEL: sign_i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sbfx w8, w0, #7, #1
; CHECK-NEXT:    orr w0, w8, #0x1
; CHECK-NEXT:    ret
  %c = icmp sgt i8 %a, -1
  %res = select i1 %c, i8 1, i8 -1
  ret i8 %res
}

define i16 @sign_i16(i16 %a) {
; CHECK-LABEL: sign_i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sbfx w8, w0, #15, #1
; CHECK-NEXT:    orr w0, w8, #0x1
; CHECK-NEXT:    ret
  %c = icmp sgt i16 %a, -1
  %res = select i1 %c, i16 1, i16 -1
  ret i16 %res
}

define i32 @sign_i32(i32 %a) {
; CHECK-LABEL: sign_i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    asr w8, w0, #31
; CHECK-NEXT:    orr w0, w8, #0x1
; CHECK-NEXT:    ret
  %c = icmp sgt i32 %a, -1
  %res = select i1 %c, i32 1, i32 -1
  ret i32 %res
}

define i64 @sign_i64(i64 %a) {
; CHECK-LABEL: sign_i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    asr x8, x0, #63
; CHECK-NEXT:    orr x0, x8, #0x1
; CHECK-NEXT:    ret
  %c = icmp sgt i64 %a, -1
  %res = select i1 %c, i64 1, i64 -1
  ret i64 %res
}


define i64 @not_sign_i64(i64 %a) {
; CHECK-LABEL: not_sign_i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    cmp x0, #0 // =0
; CHECK-NEXT:    mov w8, #1
; CHECK-NEXT:    cneg x0, x8, le
; CHECK-NEXT:    ret
  %c = icmp sgt i64 %a, 0
  %res = select i1 %c, i64 1, i64 -1
  ret i64 %res
}

define i64 @not_sign_i64_2(i64 %a) {
; CHECK-LABEL: not_sign_i64_2:
; CHECK:       // %bb.0:
; CHECK-NEXT:    asr x0, x0, #63
; CHECK-NEXT:    ret
  %c = icmp sgt i64 %a, -1
  %res = select i1 %c, i64 0, i64 -1
  ret i64 %res
}

define i64 @not_sign_i64_3(i64 %a) {
; CHECK-LABEL: not_sign_i64_3:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mvn x8, x0
; CHECK-NEXT:    lsr x0, x8, #63
; CHECK-NEXT:    ret
  %c = icmp sgt i64 %a, -1
  %res = select i1 %c, i64 1, i64 0
  ret i64 %res
}

define i64 @not_sign_i64_4(i64 %a) {
; CHECK-LABEL: not_sign_i64_4:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x0, #-1
; CHECK-NEXT:    ret
  %c = icmp ugt i64 %a, -1
  %res = select i1 %c, i64 1, i64 -1
  ret i64 %res
}

define <7 x i8> @sign_7xi8(<7 x i8> %a) {
; CHECK-LABEL: sign_7xi8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sshr v0.8b, v0.8b, #7
; CHECK-NEXT:    movi v1.8b, #1
; CHECK-NEXT:    orr v0.8b, v0.8b, v1.8b
; CHECK-NEXT:    ret
  %c = icmp sgt <7 x i8> %a, <i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1>
  %res = select <7 x i1> %c, <7 x i8> <i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1>, <7 x i8> <i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1>
  ret <7 x i8> %res
}

define <8 x i8> @sign_8xi8(<8 x i8> %a) {
; CHECK-LABEL: sign_8xi8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sshr v0.8b, v0.8b, #7
; CHECK-NEXT:    movi v1.8b, #1
; CHECK-NEXT:    orr v0.8b, v0.8b, v1.8b
; CHECK-NEXT:    ret
  %c = icmp sgt <8 x i8> %a, <i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1>
  %res = select <8 x i1> %c, <8 x i8> <i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1>, <8 x i8> <i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1>
  ret <8 x i8> %res
}

define <16 x i8> @sign_16xi8(<16 x i8> %a) {
; CHECK-LABEL: sign_16xi8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sshr v0.16b, v0.16b, #7
; CHECK-NEXT:    movi v1.16b, #1
; CHECK-NEXT:    orr v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ret
  %c = icmp sgt <16 x i8> %a, <i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1>
  %res = select <16 x i1> %c, <16 x i8> <i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1>, <16 x i8> <i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1>
  ret <16 x i8> %res
}

define <3 x i32> @sign_3xi32(<3 x i32> %a) {
; CHECK-LABEL: sign_3xi32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sshr v0.4s, v0.4s, #31
; CHECK-NEXT:    orr v0.4s, #1
; CHECK-NEXT:    ret
  %c = icmp sgt <3 x i32> %a, <i32 -1, i32 -1, i32 -1>
  %res = select <3 x i1> %c, <3 x i32> <i32 1, i32 1, i32 1>, <3 x i32> <i32 -1, i32 -1, i32 -1>
  ret <3 x i32> %res
}

define <4 x i32> @sign_4xi32(<4 x i32> %a) {
; CHECK-LABEL: sign_4xi32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sshr v0.4s, v0.4s, #31
; CHECK-NEXT:    orr v0.4s, #1
; CHECK-NEXT:    ret
  %c = icmp sgt <4 x i32> %a, <i32 -1, i32 -1, i32 -1, i32 -1>
  %res = select <4 x i1> %c, <4 x i32> <i32 1, i32 1, i32 1, i32 1>, <4 x i32> <i32 -1, i32 -1, i32 -1, i32 -1>
  ret <4 x i32> %res
}

define <4 x i32> @sign_4xi32_multi_use(<4 x i32> %a) {
; CHECK-LABEL: sign_4xi32_multi_use:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sub sp, sp, #32 // =32
; CHECK-NEXT:    str x30, [sp, #16] // 8-byte Folded Spill
; CHECK-NEXT:    .cfi_def_cfa_offset 32
; CHECK-NEXT:    .cfi_offset w30, -16
; CHECK-NEXT:    movi v1.2d, #0xffffffffffffffff
; CHECK-NEXT:    sshr v2.4s, v0.4s, #31
; CHECK-NEXT:    cmgt v0.4s, v0.4s, v1.4s
; CHECK-NEXT:    orr v2.4s, #1
; CHECK-NEXT:    xtn v0.4h, v0.4s
; CHECK-NEXT:    str q2, [sp] // 16-byte Folded Spill
; CHECK-NEXT:    bl use_4xi1
; CHECK-NEXT:    ldr q0, [sp] // 16-byte Folded Reload
; CHECK-NEXT:    ldr x30, [sp, #16] // 8-byte Folded Reload
; CHECK-NEXT:    add sp, sp, #32 // =32
; CHECK-NEXT:    ret
  %c = icmp sgt <4 x i32> %a, <i32 -1, i32 -1, i32 -1, i32 -1>
  %res = select <4 x i1> %c, <4 x i32> <i32 1, i32 1, i32 1, i32 1>, <4 x i32> <i32 -1, i32 -1, i32 -1, i32 -1>
  call void @use_4xi1(<4 x i1> %c)
  ret <4 x i32> %res
}

; Second icmp operand breaks sign pattern.
define <4 x i32> @not_sign_4xi32(<4 x i32> %a) {
; CHECK-LABEL: not_sign_4xi32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x8, .LCPI16_0
; CHECK-NEXT:    ldr q1, [x8, :lo12:.LCPI16_0]
; CHECK-NEXT:    cmgt v0.4s, v0.4s, v1.4s
; CHECK-NEXT:    movi v1.4s, #1
; CHECK-NEXT:    and v1.16b, v0.16b, v1.16b
; CHECK-NEXT:    orn v0.16b, v1.16b, v0.16b
; CHECK-NEXT:    ret
  %c = icmp sgt <4 x i32> %a, <i32 1, i32 -1, i32 -1, i32 -1>
  %res = select <4 x i1> %c, <4 x i32> <i32 1, i32 1, i32 1, i32 1>, <4 x i32> <i32 -1, i32 -1, i32 -1, i32 -1>
  ret <4 x i32> %res
}

; First select operand breaks sign pattern.
define <4 x i32> @not_sign_4xi32_2(<4 x i32> %a) {
; CHECK-LABEL: not_sign_4xi32_2:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x8, .LCPI17_0
; CHECK-NEXT:    ldr q1, [x8, :lo12:.LCPI17_0]
; CHECK-NEXT:    movi v2.2d, #0xffffffffffffffff
; CHECK-NEXT:    cmgt v0.4s, v0.4s, v2.4s
; CHECK-NEXT:    and v1.16b, v0.16b, v1.16b
; CHECK-NEXT:    orn v0.16b, v1.16b, v0.16b
; CHECK-NEXT:    ret
  %c = icmp sgt <4 x i32> %a, <i32 -1, i32 -1, i32 -1, i32 -1>
  %res = select <4 x i1> %c, <4 x i32> <i32 1, i32 1, i32 -1, i32 1>, <4 x i32> <i32 -1, i32 -1, i32 -1, i32 -1>
  ret <4 x i32> %res
}

; Second select operand breaks sign pattern.
define <4 x i32> @not_sign_4xi32_3(<4 x i32> %a) {
; CHECK-LABEL: not_sign_4xi32_3:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x8, .LCPI18_0
; CHECK-NEXT:    ldr q1, [x8, :lo12:.LCPI18_0]
; CHECK-NEXT:    movi v2.2d, #0xffffffffffffffff
; CHECK-NEXT:    cmgt v0.4s, v0.4s, v2.4s
; CHECK-NEXT:    movi v2.4s, #1
; CHECK-NEXT:    bsl v0.16b, v2.16b, v1.16b
; CHECK-NEXT:    ret
  %c = icmp sgt <4 x i32> %a, <i32 -1, i32 -1, i32 -1, i32 -1>
  %res = select <4 x i1> %c, <4 x i32> <i32 1, i32 1, i32 1, i32 1>, <4 x i32> <i32 -1, i32 -1, i32 -1, i32 1>
  ret <4 x i32> %res
}

; i65 is not legal.
define <4 x i65> @sign_4xi65(<4 x i65> %a) {
; CHECK-LABEL: sign_4xi65:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sbfx x8, x1, #0, #1
; CHECK-NEXT:    sbfx x9, x7, #0, #1
; CHECK-NEXT:    orr x6, x9, #0x1
; CHECK-NEXT:    lsr x7, x9, #63
; CHECK-NEXT:    orr x9, x8, #0x1
; CHECK-NEXT:    lsr x1, x8, #63
; CHECK-NEXT:    fmov d0, x9
; CHECK-NEXT:    sbfx x10, x5, #0, #1
; CHECK-NEXT:    sbfx x11, x3, #0, #1
; CHECK-NEXT:    mov v0.d[1], x1
; CHECK-NEXT:    orr x2, x11, #0x1
; CHECK-NEXT:    lsr x3, x11, #63
; CHECK-NEXT:    orr x4, x10, #0x1
; CHECK-NEXT:    lsr x5, x10, #63
; CHECK-NEXT:    fmov x0, d0
; CHECK-NEXT:    ret
  %c = icmp sgt <4 x i65> %a, <i65 -1, i65 -1, i65 -1, i65 -1>
  %res = select <4 x i1> %c, <4 x i65> <i65 1, i65 1, i65 1, i65 1>, <4 x i65 > <i65 -1, i65 -1, i65 -1, i65 -1>
  ret <4 x i65> %res
}

declare void @use_4xi1(<4 x i1>)
