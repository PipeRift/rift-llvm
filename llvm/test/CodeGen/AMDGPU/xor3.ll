; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=amdgcn-amd-mesa3d -mcpu=gfx900 -verify-machineinstrs | FileCheck -check-prefix=GFX9 %s
; RUN: llc < %s -mtriple=amdgcn-amd-mesa3d -mcpu=gfx1010 -verify-machineinstrs | FileCheck -check-prefix=GFX10 %s

; ===================================================================================
; V_XOR3_B32
; ===================================================================================

define amdgpu_ps float @xor3(i32 %a, i32 %b, i32 %c) {
; GFX9-LABEL: xor3:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    v_xor_b32_e32 v0, v0, v1
; GFX9-NEXT:    v_xor_b32_e32 v0, v0, v2
; GFX9-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: xor3:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    v_xor3_b32 v0, v0, v1, v2
; GFX10-NEXT:    ; return to shader part epilog
  %x = xor i32 %a, %b
  %result = xor i32 %x, %c
  %bc = bitcast i32 %result to float
  ret float %bc
}

define amdgpu_ps float @xor3_vgpr_b(i32 inreg %a, i32 %b, i32 inreg %c) {
; GFX9-LABEL: xor3_vgpr_b:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    v_xor_b32_e32 v0, s2, v0
; GFX9-NEXT:    v_xor_b32_e32 v0, s3, v0
; GFX9-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: xor3_vgpr_b:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    v_xor3_b32 v0, s2, v0, s3
; GFX10-NEXT:    ; return to shader part epilog
  %x = xor i32 %a, %b
  %result = xor i32 %x, %c
  %bc = bitcast i32 %result to float
  ret float %bc
}

define amdgpu_ps float @xor3_vgpr_all2(i32 %a, i32 %b, i32 %c) {
; GFX9-LABEL: xor3_vgpr_all2:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    v_xor_b32_e32 v1, v1, v2
; GFX9-NEXT:    v_xor_b32_e32 v0, v0, v1
; GFX9-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: xor3_vgpr_all2:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    v_xor3_b32 v0, v1, v2, v0
; GFX10-NEXT:    ; return to shader part epilog
  %x = xor i32 %b, %c
  %result = xor i32 %a, %x
  %bc = bitcast i32 %result to float
  ret float %bc
}

define amdgpu_ps float @xor3_vgpr_bc(i32 inreg %a, i32 %b, i32 %c) {
; GFX9-LABEL: xor3_vgpr_bc:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    v_xor_b32_e32 v0, s2, v0
; GFX9-NEXT:    v_xor_b32_e32 v0, v0, v1
; GFX9-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: xor3_vgpr_bc:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    v_xor3_b32 v0, s2, v0, v1
; GFX10-NEXT:    ; return to shader part epilog
  %x = xor i32 %a, %b
  %result = xor i32 %x, %c
  %bc = bitcast i32 %result to float
  ret float %bc
}

define amdgpu_ps float @xor3_vgpr_const(i32 %a, i32 %b) {
; GFX9-LABEL: xor3_vgpr_const:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    v_xor_b32_e32 v0, v0, v1
; GFX9-NEXT:    v_xor_b32_e32 v0, 16, v0
; GFX9-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: xor3_vgpr_const:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    v_xor3_b32 v0, v0, v1, 16
; GFX10-NEXT:    ; return to shader part epilog
  %x = xor i32 %a, %b
  %result = xor i32 %x, 16
  %bc = bitcast i32 %result to float
  ret float %bc
}

define amdgpu_ps <2 x float> @xor3_multiuse_outer(i32 %a, i32 %b, i32 %c, i32 %x) {
; GFX9-LABEL: xor3_multiuse_outer:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    v_xor_b32_e32 v0, v0, v1
; GFX9-NEXT:    v_xor_b32_e32 v0, v0, v2
; GFX9-NEXT:    v_mul_lo_u32 v1, v0, v3
; GFX9-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: xor3_multiuse_outer:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    v_xor3_b32 v0, v0, v1, v2
; GFX10-NEXT:    v_mul_lo_u32 v1, v0, v3
; GFX10-NEXT:    ; return to shader part epilog
  %inner = xor i32 %a, %b
  %outer = xor i32 %inner, %c
  %x1 = mul i32 %outer, %x
  %r1 = insertelement <2 x i32> undef, i32 %outer, i32 0
  %r0 = insertelement <2 x i32> %r1, i32 %x1, i32 1
  %bc = bitcast <2 x i32> %r0 to <2 x float>
  ret <2 x float> %bc
}

define amdgpu_ps <2 x float> @xor3_multiuse_inner(i32 %a, i32 %b, i32 %c) {
; GFX9-LABEL: xor3_multiuse_inner:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    v_xor_b32_e32 v0, v0, v1
; GFX9-NEXT:    v_xor_b32_e32 v1, v0, v2
; GFX9-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: xor3_multiuse_inner:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    v_xor_b32_e32 v0, v0, v1
; GFX10-NEXT:    v_xor_b32_e32 v1, v0, v2
; GFX10-NEXT:    ; return to shader part epilog
  %inner = xor i32 %a, %b
  %outer = xor i32 %inner, %c
  %r1 = insertelement <2 x i32> undef, i32 %inner, i32 0
  %r0 = insertelement <2 x i32> %r1, i32 %outer, i32 1
  %bc = bitcast <2 x i32> %r0 to <2 x float>
  ret <2 x float> %bc
}

; A case where uniform values end up in VGPRs -- we could use v_xor3_b32 here,
; but we don't.
define amdgpu_ps float @xor3_uniform_vgpr(float inreg %a, float inreg %b, float inreg %c) {
; GFX9-LABEL: xor3_uniform_vgpr:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    v_mov_b32_e32 v2, 0x40400000
; GFX9-NEXT:    v_add_f32_e64 v0, s2, 1.0
; GFX9-NEXT:    v_add_f32_e64 v1, s3, 2.0
; GFX9-NEXT:    v_add_f32_e32 v2, s4, v2
; GFX9-NEXT:    v_xor_b32_e32 v0, v0, v1
; GFX9-NEXT:    v_xor_b32_e32 v0, v0, v2
; GFX9-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: xor3_uniform_vgpr:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    v_add_f32_e64 v0, s2, 1.0
; GFX10-NEXT:    v_add_f32_e64 v1, s3, 2.0
; GFX10-NEXT:    v_add_f32_e64 v2, 0x40400000, s4
; GFX10-NEXT:    v_xor_b32_e32 v0, v0, v1
; GFX10-NEXT:    v_xor_b32_e32 v0, v0, v2
; GFX10-NEXT:    ; return to shader part epilog
  %a1 = fadd float %a, 1.0
  %b2 = fadd float %b, 2.0
  %c3 = fadd float %c, 3.0
  %bc.a = bitcast float %a1 to i32
  %bc.b = bitcast float %b2 to i32
  %bc.c = bitcast float %c3 to i32
  %x = xor i32 %bc.a, %bc.b
  %result = xor i32 %x, %bc.c
  %bc = bitcast i32 %result to float
  ret float %bc
}
