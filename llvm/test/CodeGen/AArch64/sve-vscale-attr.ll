; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s | FileCheck %s --check-prefixes=CHECK,CHECK-NOARG
; RUN: llc -aarch64-sve-vector-bits-min=512 < %s | FileCheck %s --check-prefixes=CHECK,CHECK-ARG

target triple = "aarch64-unknown-linux-gnu"

define void @func_vscale_none(<16 x i32>* %a, <16 x i32>* %b) #0 {
; CHECK-NOARG-LABEL: func_vscale_none:
; CHECK-NOARG:       // %bb.0:
; CHECK-NOARG-NEXT:    ldp q0, q1, [x0]
; CHECK-NOARG-NEXT:    ldp q2, q3, [x1]
; CHECK-NOARG-NEXT:    ldp q4, q5, [x0, #32]
; CHECK-NOARG-NEXT:    ldp q7, q6, [x1, #32]
; CHECK-NOARG-NEXT:    add v1.4s, v1.4s, v3.4s
; CHECK-NOARG-NEXT:    add v0.4s, v0.4s, v2.4s
; CHECK-NOARG-NEXT:    add v2.4s, v5.4s, v6.4s
; CHECK-NOARG-NEXT:    add v3.4s, v4.4s, v7.4s
; CHECK-NOARG-NEXT:    stp q3, q2, [x0, #32]
; CHECK-NOARG-NEXT:    stp q0, q1, [x0]
; CHECK-NOARG-NEXT:    ret
;
; CHECK-ARG-LABEL: func_vscale_none:
; CHECK-ARG:       // %bb.0:
; CHECK-ARG-NEXT:    ptrue p0.s, vl16
; CHECK-ARG-NEXT:    ld1w { z0.s }, p0/z, [x0]
; CHECK-ARG-NEXT:    ld1w { z1.s }, p0/z, [x1]
; CHECK-ARG-NEXT:    add z0.s, p0/m, z0.s, z1.s
; CHECK-ARG-NEXT:    st1w { z0.s }, p0, [x0]
; CHECK-ARG-NEXT:    ret
  %op1 = load <16 x i32>, <16 x i32>* %a
  %op2 = load <16 x i32>, <16 x i32>* %b
  %res = add <16 x i32> %op1, %op2
  store <16 x i32> %res, <16 x i32>* %a
  ret void
}

attributes #0 = { "target-features"="+sve" }

define void @func_vscale1_1(<16 x i32>* %a, <16 x i32>* %b) #1 {
; CHECK-LABEL: func_vscale1_1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldp q0, q1, [x0]
; CHECK-NEXT:    ldp q2, q3, [x1]
; CHECK-NEXT:    ldp q4, q5, [x0, #32]
; CHECK-NEXT:    ldp q7, q6, [x1, #32]
; CHECK-NEXT:    add v1.4s, v1.4s, v3.4s
; CHECK-NEXT:    add v0.4s, v0.4s, v2.4s
; CHECK-NEXT:    add v2.4s, v5.4s, v6.4s
; CHECK-NEXT:    add v3.4s, v4.4s, v7.4s
; CHECK-NEXT:    stp q3, q2, [x0, #32]
; CHECK-NEXT:    stp q0, q1, [x0]
; CHECK-NEXT:    ret
  %op1 = load <16 x i32>, <16 x i32>* %a
  %op2 = load <16 x i32>, <16 x i32>* %b
  %res = add <16 x i32> %op1, %op2
  store <16 x i32> %res, <16 x i32>* %a
  ret void
}

attributes #1 = { "target-features"="+sve" vscale_range(1,1) }

define void @func_vscale2_2(<16 x i32>* %a, <16 x i32>* %b) #2 {
; CHECK-LABEL: func_vscale2_2:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x8, #8
; CHECK-NEXT:    ptrue p0.s, vl8
; CHECK-NEXT:    ld1w { z0.s }, p0/z, [x0, x8, lsl #2]
; CHECK-NEXT:    ld1w { z1.s }, p0/z, [x0]
; CHECK-NEXT:    ld1w { z2.s }, p0/z, [x1, x8, lsl #2]
; CHECK-NEXT:    ld1w { z3.s }, p0/z, [x1]
; CHECK-NEXT:    add z0.s, p0/m, z0.s, z2.s
; CHECK-NEXT:    add z1.s, p0/m, z1.s, z3.s
; CHECK-NEXT:    st1w { z0.s }, p0, [x0, x8, lsl #2]
; CHECK-NEXT:    st1w { z1.s }, p0, [x0]
; CHECK-NEXT:    ret
  %op1 = load <16 x i32>, <16 x i32>* %a
  %op2 = load <16 x i32>, <16 x i32>* %b
  %res = add <16 x i32> %op1, %op2
  store <16 x i32> %res, <16 x i32>* %a
  ret void
}

attributes #2 = { "target-features"="+sve" vscale_range(2,2) }

define void @func_vscale2_4(<16 x i32>* %a, <16 x i32>* %b) #3 {
; CHECK-LABEL: func_vscale2_4:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x8, #8
; CHECK-NEXT:    ptrue p0.s, vl8
; CHECK-NEXT:    ld1w { z0.s }, p0/z, [x0, x8, lsl #2]
; CHECK-NEXT:    ld1w { z1.s }, p0/z, [x0]
; CHECK-NEXT:    ld1w { z2.s }, p0/z, [x1, x8, lsl #2]
; CHECK-NEXT:    ld1w { z3.s }, p0/z, [x1]
; CHECK-NEXT:    add z0.s, p0/m, z0.s, z2.s
; CHECK-NEXT:    add z1.s, p0/m, z1.s, z3.s
; CHECK-NEXT:    st1w { z0.s }, p0, [x0, x8, lsl #2]
; CHECK-NEXT:    st1w { z1.s }, p0, [x0]
; CHECK-NEXT:    ret
  %op1 = load <16 x i32>, <16 x i32>* %a
  %op2 = load <16 x i32>, <16 x i32>* %b
  %res = add <16 x i32> %op1, %op2
  store <16 x i32> %res, <16 x i32>* %a
  ret void
}

attributes #3 = { "target-features"="+sve" vscale_range(2,4) }

define void @func_vscale4_4(<16 x i32>* %a, <16 x i32>* %b) #4 {
; CHECK-LABEL: func_vscale4_4:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.s, vl16
; CHECK-NEXT:    ld1w { z0.s }, p0/z, [x0]
; CHECK-NEXT:    ld1w { z1.s }, p0/z, [x1]
; CHECK-NEXT:    add z0.s, p0/m, z0.s, z1.s
; CHECK-NEXT:    st1w { z0.s }, p0, [x0]
; CHECK-NEXT:    ret
  %op1 = load <16 x i32>, <16 x i32>* %a
  %op2 = load <16 x i32>, <16 x i32>* %b
  %res = add <16 x i32> %op1, %op2
  store <16 x i32> %res, <16 x i32>* %a
  ret void
}

attributes #4 = { "target-features"="+sve" vscale_range(4,4) }

define void @func_vscale8_8(<16 x i32>* %a, <16 x i32>* %b) #5 {
; CHECK-LABEL: func_vscale8_8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.s, vl16
; CHECK-NEXT:    ld1w { z0.s }, p0/z, [x0]
; CHECK-NEXT:    ld1w { z1.s }, p0/z, [x1]
; CHECK-NEXT:    add z0.s, p0/m, z0.s, z1.s
; CHECK-NEXT:    st1w { z0.s }, p0, [x0]
; CHECK-NEXT:    ret
  %op1 = load <16 x i32>, <16 x i32>* %a
  %op2 = load <16 x i32>, <16 x i32>* %b
  %res = add <16 x i32> %op1, %op2
  store <16 x i32> %res, <16 x i32>* %a
  ret void
}

attributes #5 = { "target-features"="+sve" vscale_range(8,8) }
