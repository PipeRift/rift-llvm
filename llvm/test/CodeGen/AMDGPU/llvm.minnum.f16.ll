; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=amdgcn-- -mcpu=tahiti -verify-machineinstrs < %s | FileCheck -enable-var-scope -check-prefixes=SI %s
; RUN: llc -mtriple=amdgcn-- -mcpu=fiji -mattr=-flat-for-global -verify-machineinstrs < %s | FileCheck -enable-var-scope -check-prefixes=VI %s
; RUN: llc -mtriple=amdgcn-- -mcpu=gfx900 -mattr=-flat-for-global -verify-machineinstrs < %s | FileCheck -enable-var-scope -check-prefixes=GFX9 %s
; RUN: llc -mtriple=amdgcn-- -mcpu=gfx1010 -mattr=-flat-for-global -verify-machineinstrs < %s | FileCheck -enable-var-scope -check-prefixes=GFX10 %s

declare half @llvm.minnum.f16(half %a, half %b)
declare <2 x half> @llvm.minnum.v2f16(<2 x half> %a, <2 x half> %b)
declare <3 x half> @llvm.minnum.v3f16(<3 x half> %a, <3 x half> %b)
declare <4 x half> @llvm.minnum.v4f16(<4 x half> %a, <4 x half> %b)

define amdgpu_kernel void @minnum_f16_ieee(
; SI-LABEL: minnum_f16_ieee:
; SI:       ; %bb.0: ; %entry
; SI-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x9
; SI-NEXT:    s_load_dwordx2 s[8:9], s[0:1], 0xd
; SI-NEXT:    s_mov_b32 s3, 0xf000
; SI-NEXT:    s_mov_b32 s2, -1
; SI-NEXT:    s_mov_b32 s14, s2
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    s_mov_b32 s12, s6
; SI-NEXT:    s_mov_b32 s13, s7
; SI-NEXT:    s_mov_b32 s15, s3
; SI-NEXT:    s_mov_b32 s10, s2
; SI-NEXT:    s_mov_b32 s11, s3
; SI-NEXT:    buffer_load_ushort v0, off, s[12:15], 0 glc
; SI-NEXT:    s_waitcnt vmcnt(0)
; SI-NEXT:    buffer_load_ushort v1, off, s[8:11], 0 glc
; SI-NEXT:    s_waitcnt vmcnt(0)
; SI-NEXT:    s_mov_b32 s0, s4
; SI-NEXT:    s_mov_b32 s1, s5
; SI-NEXT:    v_cvt_f32_f16_e32 v0, v0
; SI-NEXT:    v_cvt_f32_f16_e32 v1, v1
; SI-NEXT:    v_mul_f32_e32 v0, 1.0, v0
; SI-NEXT:    v_mul_f32_e32 v1, 1.0, v1
; SI-NEXT:    v_min_f32_e32 v0, v0, v1
; SI-NEXT:    v_cvt_f16_f32_e32 v0, v0
; SI-NEXT:    buffer_store_short v0, off, s[0:3], 0
; SI-NEXT:    s_endpgm
;
; VI-LABEL: minnum_f16_ieee:
; VI:       ; %bb.0: ; %entry
; VI-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x24
; VI-NEXT:    s_load_dwordx2 s[8:9], s[0:1], 0x34
; VI-NEXT:    s_mov_b32 s3, 0xf000
; VI-NEXT:    s_mov_b32 s2, -1
; VI-NEXT:    s_mov_b32 s14, s2
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    s_mov_b32 s12, s6
; VI-NEXT:    s_mov_b32 s13, s7
; VI-NEXT:    s_mov_b32 s15, s3
; VI-NEXT:    s_mov_b32 s10, s2
; VI-NEXT:    s_mov_b32 s11, s3
; VI-NEXT:    buffer_load_ushort v0, off, s[12:15], 0 glc
; VI-NEXT:    s_waitcnt vmcnt(0)
; VI-NEXT:    buffer_load_ushort v1, off, s[8:11], 0 glc
; VI-NEXT:    s_waitcnt vmcnt(0)
; VI-NEXT:    s_mov_b32 s0, s4
; VI-NEXT:    s_mov_b32 s1, s5
; VI-NEXT:    v_max_f16_e32 v0, v0, v0
; VI-NEXT:    v_max_f16_e32 v1, v1, v1
; VI-NEXT:    v_min_f16_e32 v0, v0, v1
; VI-NEXT:    buffer_store_short v0, off, s[0:3], 0
; VI-NEXT:    s_endpgm
;
; GFX9-LABEL: minnum_f16_ieee:
; GFX9:       ; %bb.0: ; %entry
; GFX9-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x24
; GFX9-NEXT:    s_load_dwordx2 s[8:9], s[0:1], 0x34
; GFX9-NEXT:    s_mov_b32 s3, 0xf000
; GFX9-NEXT:    s_mov_b32 s2, -1
; GFX9-NEXT:    s_mov_b32 s14, s2
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    s_mov_b32 s12, s6
; GFX9-NEXT:    s_mov_b32 s13, s7
; GFX9-NEXT:    s_mov_b32 s15, s3
; GFX9-NEXT:    s_mov_b32 s10, s2
; GFX9-NEXT:    s_mov_b32 s11, s3
; GFX9-NEXT:    buffer_load_ushort v0, off, s[12:15], 0 glc
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    buffer_load_ushort v1, off, s[8:11], 0 glc
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    s_mov_b32 s0, s4
; GFX9-NEXT:    s_mov_b32 s1, s5
; GFX9-NEXT:    v_max_f16_e32 v0, v0, v0
; GFX9-NEXT:    v_max_f16_e32 v1, v1, v1
; GFX9-NEXT:    v_min_f16_e32 v0, v0, v1
; GFX9-NEXT:    buffer_store_short v0, off, s[0:3], 0
; GFX9-NEXT:    s_endpgm
;
; GFX10-LABEL: minnum_f16_ieee:
; GFX10:       ; %bb.0: ; %entry
; GFX10-NEXT:    s_clause 0x1
; GFX10-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x24
; GFX10-NEXT:    s_load_dwordx2 s[8:9], s[0:1], 0x34
; GFX10-NEXT:    s_mov_b32 s2, -1
; GFX10-NEXT:    s_mov_b32 s3, 0x31016000
; GFX10-NEXT:    s_mov_b32 s14, s2
; GFX10-NEXT:    s_mov_b32 s15, s3
; GFX10-NEXT:    s_mov_b32 s10, s2
; GFX10-NEXT:    s_mov_b32 s11, s3
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    s_mov_b32 s12, s6
; GFX10-NEXT:    s_mov_b32 s13, s7
; GFX10-NEXT:    s_mov_b32 s0, s4
; GFX10-NEXT:    buffer_load_ushort v0, off, s[12:15], 0 glc dlc
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    buffer_load_ushort v1, off, s[8:11], 0 glc dlc
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    s_mov_b32 s1, s5
; GFX10-NEXT:    v_max_f16_e32 v0, v0, v0
; GFX10-NEXT:    v_max_f16_e32 v1, v1, v1
; GFX10-NEXT:    v_min_f16_e32 v0, v0, v1
; GFX10-NEXT:    buffer_store_short v0, off, s[0:3], 0
; GFX10-NEXT:    s_endpgm
    half addrspace(1)* %r,
    half addrspace(1)* %a,
    half addrspace(1)* %b) #0 {
entry:
  %a.val = load volatile half, half addrspace(1)* %a
  %b.val = load volatile half, half addrspace(1)* %b
  %r.val = call half @llvm.minnum.f16(half %a.val, half %b.val)
  store half %r.val, half addrspace(1)* %r
  ret void
}

define amdgpu_ps half @minnum_f16_no_ieee(half %a, half %b) #0 {
; SI-LABEL: minnum_f16_no_ieee:
; SI:       ; %bb.0:
; SI-NEXT:    v_cvt_f16_f32_e32 v1, v1
; SI-NEXT:    v_cvt_f16_f32_e32 v0, v0
; SI-NEXT:    v_cvt_f32_f16_e32 v1, v1
; SI-NEXT:    v_cvt_f32_f16_e32 v0, v0
; SI-NEXT:    v_min_f32_e32 v0, v0, v1
; SI-NEXT:    ; return to shader part epilog
;
; VI-LABEL: minnum_f16_no_ieee:
; VI:       ; %bb.0:
; VI-NEXT:    v_min_f16_e32 v0, v0, v1
; VI-NEXT:    ; return to shader part epilog
;
; GFX9-LABEL: minnum_f16_no_ieee:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    v_min_f16_e32 v0, v0, v1
; GFX9-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: minnum_f16_no_ieee:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    v_min_f16_e32 v0, v0, v1
; GFX10-NEXT:    ; return to shader part epilog
  %r.val = call half @llvm.minnum.f16(half %a, half %b)
  ret half %r.val
}

define amdgpu_kernel void @minnum_f16_imm_a(
; SI-LABEL: minnum_f16_imm_a:
; SI:       ; %bb.0: ; %entry
; SI-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x9
; SI-NEXT:    s_mov_b32 s3, 0xf000
; SI-NEXT:    s_mov_b32 s2, -1
; SI-NEXT:    s_mov_b32 s10, s2
; SI-NEXT:    s_mov_b32 s11, s3
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    s_mov_b32 s8, s6
; SI-NEXT:    s_mov_b32 s9, s7
; SI-NEXT:    buffer_load_ushort v0, off, s[8:11], 0
; SI-NEXT:    s_mov_b32 s0, s4
; SI-NEXT:    s_mov_b32 s1, s5
; SI-NEXT:    s_waitcnt vmcnt(0)
; SI-NEXT:    v_cvt_f32_f16_e32 v0, v0
; SI-NEXT:    v_mul_f32_e32 v0, 1.0, v0
; SI-NEXT:    v_min_f32_e32 v0, 0x40400000, v0
; SI-NEXT:    v_cvt_f16_f32_e32 v0, v0
; SI-NEXT:    buffer_store_short v0, off, s[0:3], 0
; SI-NEXT:    s_endpgm
;
; VI-LABEL: minnum_f16_imm_a:
; VI:       ; %bb.0: ; %entry
; VI-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x24
; VI-NEXT:    s_mov_b32 s3, 0xf000
; VI-NEXT:    s_mov_b32 s2, -1
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    s_mov_b32 s0, s4
; VI-NEXT:    s_mov_b32 s1, s5
; VI-NEXT:    s_mov_b32 s4, s6
; VI-NEXT:    s_mov_b32 s5, s7
; VI-NEXT:    s_mov_b32 s6, s2
; VI-NEXT:    s_mov_b32 s7, s3
; VI-NEXT:    buffer_load_ushort v0, off, s[4:7], 0
; VI-NEXT:    s_waitcnt vmcnt(0)
; VI-NEXT:    v_max_f16_e32 v0, v0, v0
; VI-NEXT:    v_min_f16_e32 v0, 0x4200, v0
; VI-NEXT:    buffer_store_short v0, off, s[0:3], 0
; VI-NEXT:    s_endpgm
;
; GFX9-LABEL: minnum_f16_imm_a:
; GFX9:       ; %bb.0: ; %entry
; GFX9-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x24
; GFX9-NEXT:    s_mov_b32 s3, 0xf000
; GFX9-NEXT:    s_mov_b32 s2, -1
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    s_mov_b32 s0, s4
; GFX9-NEXT:    s_mov_b32 s1, s5
; GFX9-NEXT:    s_mov_b32 s4, s6
; GFX9-NEXT:    s_mov_b32 s5, s7
; GFX9-NEXT:    s_mov_b32 s6, s2
; GFX9-NEXT:    s_mov_b32 s7, s3
; GFX9-NEXT:    buffer_load_ushort v0, off, s[4:7], 0
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    v_max_f16_e32 v0, v0, v0
; GFX9-NEXT:    v_min_f16_e32 v0, 0x4200, v0
; GFX9-NEXT:    buffer_store_short v0, off, s[0:3], 0
; GFX9-NEXT:    s_endpgm
;
; GFX10-LABEL: minnum_f16_imm_a:
; GFX10:       ; %bb.0: ; %entry
; GFX10-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x24
; GFX10-NEXT:    s_mov_b32 s6, -1
; GFX10-NEXT:    s_mov_b32 s7, 0x31016000
; GFX10-NEXT:    s_mov_b32 s10, s6
; GFX10-NEXT:    s_mov_b32 s11, s7
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    s_mov_b32 s8, s2
; GFX10-NEXT:    s_mov_b32 s9, s3
; GFX10-NEXT:    s_mov_b32 s4, s0
; GFX10-NEXT:    buffer_load_ushort v0, off, s[8:11], 0
; GFX10-NEXT:    s_mov_b32 s5, s1
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    v_max_f16_e32 v0, v0, v0
; GFX10-NEXT:    v_min_f16_e32 v0, 0x4200, v0
; GFX10-NEXT:    buffer_store_short v0, off, s[4:7], 0
; GFX10-NEXT:    s_endpgm
    half addrspace(1)* %r,
    half addrspace(1)* %b) #0 {
entry:
  %b.val = load half, half addrspace(1)* %b
  %r.val = call half @llvm.minnum.f16(half 3.0, half %b.val)
  store half %r.val, half addrspace(1)* %r
  ret void
}

define amdgpu_kernel void @minnum_f16_imm_b(
; SI-LABEL: minnum_f16_imm_b:
; SI:       ; %bb.0: ; %entry
; SI-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x9
; SI-NEXT:    s_mov_b32 s3, 0xf000
; SI-NEXT:    s_mov_b32 s2, -1
; SI-NEXT:    s_mov_b32 s10, s2
; SI-NEXT:    s_mov_b32 s11, s3
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    s_mov_b32 s8, s6
; SI-NEXT:    s_mov_b32 s9, s7
; SI-NEXT:    buffer_load_ushort v0, off, s[8:11], 0
; SI-NEXT:    s_mov_b32 s0, s4
; SI-NEXT:    s_mov_b32 s1, s5
; SI-NEXT:    s_waitcnt vmcnt(0)
; SI-NEXT:    v_cvt_f32_f16_e32 v0, v0
; SI-NEXT:    v_mul_f32_e32 v0, 1.0, v0
; SI-NEXT:    v_min_f32_e32 v0, 4.0, v0
; SI-NEXT:    v_cvt_f16_f32_e32 v0, v0
; SI-NEXT:    buffer_store_short v0, off, s[0:3], 0
; SI-NEXT:    s_endpgm
;
; VI-LABEL: minnum_f16_imm_b:
; VI:       ; %bb.0: ; %entry
; VI-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x24
; VI-NEXT:    s_mov_b32 s3, 0xf000
; VI-NEXT:    s_mov_b32 s2, -1
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    s_mov_b32 s0, s4
; VI-NEXT:    s_mov_b32 s1, s5
; VI-NEXT:    s_mov_b32 s4, s6
; VI-NEXT:    s_mov_b32 s5, s7
; VI-NEXT:    s_mov_b32 s6, s2
; VI-NEXT:    s_mov_b32 s7, s3
; VI-NEXT:    buffer_load_ushort v0, off, s[4:7], 0
; VI-NEXT:    s_waitcnt vmcnt(0)
; VI-NEXT:    v_max_f16_e32 v0, v0, v0
; VI-NEXT:    v_min_f16_e32 v0, 4.0, v0
; VI-NEXT:    buffer_store_short v0, off, s[0:3], 0
; VI-NEXT:    s_endpgm
;
; GFX9-LABEL: minnum_f16_imm_b:
; GFX9:       ; %bb.0: ; %entry
; GFX9-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x24
; GFX9-NEXT:    s_mov_b32 s3, 0xf000
; GFX9-NEXT:    s_mov_b32 s2, -1
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    s_mov_b32 s0, s4
; GFX9-NEXT:    s_mov_b32 s1, s5
; GFX9-NEXT:    s_mov_b32 s4, s6
; GFX9-NEXT:    s_mov_b32 s5, s7
; GFX9-NEXT:    s_mov_b32 s6, s2
; GFX9-NEXT:    s_mov_b32 s7, s3
; GFX9-NEXT:    buffer_load_ushort v0, off, s[4:7], 0
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    v_max_f16_e32 v0, v0, v0
; GFX9-NEXT:    v_min_f16_e32 v0, 4.0, v0
; GFX9-NEXT:    buffer_store_short v0, off, s[0:3], 0
; GFX9-NEXT:    s_endpgm
;
; GFX10-LABEL: minnum_f16_imm_b:
; GFX10:       ; %bb.0: ; %entry
; GFX10-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x24
; GFX10-NEXT:    s_mov_b32 s6, -1
; GFX10-NEXT:    s_mov_b32 s7, 0x31016000
; GFX10-NEXT:    s_mov_b32 s10, s6
; GFX10-NEXT:    s_mov_b32 s11, s7
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    s_mov_b32 s8, s2
; GFX10-NEXT:    s_mov_b32 s9, s3
; GFX10-NEXT:    s_mov_b32 s4, s0
; GFX10-NEXT:    buffer_load_ushort v0, off, s[8:11], 0
; GFX10-NEXT:    s_mov_b32 s5, s1
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    v_max_f16_e32 v0, v0, v0
; GFX10-NEXT:    v_min_f16_e32 v0, 4.0, v0
; GFX10-NEXT:    buffer_store_short v0, off, s[4:7], 0
; GFX10-NEXT:    s_endpgm
    half addrspace(1)* %r,
    half addrspace(1)* %a) #0 {
entry:
  %a.val = load half, half addrspace(1)* %a
  %r.val = call half @llvm.minnum.f16(half %a.val, half 4.0)
  store half %r.val, half addrspace(1)* %r
  ret void
}

define amdgpu_kernel void @minnum_v2f16_ieee(
; SI-LABEL: minnum_v2f16_ieee:
; SI:       ; %bb.0: ; %entry
; SI-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x9
; SI-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0xd
; SI-NEXT:    s_mov_b32 s3, 0xf000
; SI-NEXT:    s_mov_b32 s2, -1
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    s_load_dword s6, s[6:7], 0x0
; SI-NEXT:    s_load_dword s0, s[0:1], 0x0
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    s_lshr_b32 s1, s6, 16
; SI-NEXT:    v_cvt_f32_f16_e32 v1, s0
; SI-NEXT:    s_lshr_b32 s0, s0, 16
; SI-NEXT:    v_cvt_f32_f16_e32 v2, s0
; SI-NEXT:    v_cvt_f32_f16_e32 v3, s1
; SI-NEXT:    v_cvt_f32_f16_e32 v0, s6
; SI-NEXT:    v_mul_f32_e32 v1, 1.0, v1
; SI-NEXT:    v_mul_f32_e32 v2, 1.0, v2
; SI-NEXT:    v_mul_f32_e32 v3, 1.0, v3
; SI-NEXT:    v_mul_f32_e32 v0, 1.0, v0
; SI-NEXT:    v_min_f32_e32 v2, v3, v2
; SI-NEXT:    v_min_f32_e32 v0, v0, v1
; SI-NEXT:    v_cvt_f16_f32_e32 v2, v2
; SI-NEXT:    v_cvt_f16_f32_e32 v0, v0
; SI-NEXT:    s_mov_b32 s0, s4
; SI-NEXT:    s_mov_b32 s1, s5
; SI-NEXT:    v_lshlrev_b32_e32 v1, 16, v2
; SI-NEXT:    v_or_b32_e32 v0, v0, v1
; SI-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; SI-NEXT:    s_endpgm
;
; VI-LABEL: minnum_v2f16_ieee:
; VI:       ; %bb.0: ; %entry
; VI-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x24
; VI-NEXT:    s_load_dwordx2 s[8:9], s[0:1], 0x34
; VI-NEXT:    s_mov_b32 s3, 0xf000
; VI-NEXT:    s_mov_b32 s2, -1
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    s_mov_b32 s0, s4
; VI-NEXT:    s_mov_b32 s1, s5
; VI-NEXT:    s_load_dword s4, s[6:7], 0x0
; VI-NEXT:    s_load_dword s5, s[8:9], 0x0
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    v_max_f16_e64 v1, s4, s4
; VI-NEXT:    v_max_f16_e64 v0, s5, s5
; VI-NEXT:    s_lshr_b32 s4, s4, 16
; VI-NEXT:    s_lshr_b32 s5, s5, 16
; VI-NEXT:    v_min_f16_e32 v0, v1, v0
; VI-NEXT:    v_max_f16_e64 v1, s5, s5
; VI-NEXT:    v_max_f16_e64 v2, s4, s4
; VI-NEXT:    v_min_f16_sdwa v1, v2, v1 dst_sel:WORD_1 dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:DWORD
; VI-NEXT:    v_or_b32_e32 v0, v0, v1
; VI-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; VI-NEXT:    s_endpgm
;
; GFX9-LABEL: minnum_v2f16_ieee:
; GFX9:       ; %bb.0: ; %entry
; GFX9-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x24
; GFX9-NEXT:    s_load_dwordx2 s[8:9], s[0:1], 0x34
; GFX9-NEXT:    s_mov_b32 s3, 0xf000
; GFX9-NEXT:    s_mov_b32 s2, -1
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    s_mov_b32 s0, s4
; GFX9-NEXT:    s_load_dword s10, s[6:7], 0x0
; GFX9-NEXT:    s_load_dword s11, s[8:9], 0x0
; GFX9-NEXT:    s_mov_b32 s1, s5
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    v_pk_max_f16 v1, s10, s10
; GFX9-NEXT:    v_pk_max_f16 v0, s11, s11
; GFX9-NEXT:    v_pk_min_f16 v0, v1, v0
; GFX9-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; GFX9-NEXT:    s_endpgm
;
; GFX10-LABEL: minnum_v2f16_ieee:
; GFX10:       ; %bb.0: ; %entry
; GFX10-NEXT:    s_clause 0x1
; GFX10-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0x34
; GFX10-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x24
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    s_load_dword s0, s[2:3], 0x0
; GFX10-NEXT:    s_load_dword s1, s[6:7], 0x0
; GFX10-NEXT:    s_mov_b32 s7, 0x31016000
; GFX10-NEXT:    s_mov_b32 s6, -1
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    v_pk_max_f16 v0, s0, s0
; GFX10-NEXT:    v_pk_max_f16 v1, s1, s1
; GFX10-NEXT:    v_pk_min_f16 v0, v1, v0
; GFX10-NEXT:    buffer_store_dword v0, off, s[4:7], 0
; GFX10-NEXT:    s_endpgm
    <2 x half> addrspace(1)* %r,
    <2 x half> addrspace(1)* %a,
    <2 x half> addrspace(1)* %b) #0 {
entry:
  %a.val = load <2 x half>, <2 x half> addrspace(1)* %a
  %b.val = load <2 x half>, <2 x half> addrspace(1)* %b
  %r.val = call <2 x half> @llvm.minnum.v2f16(<2 x half> %a.val, <2 x half> %b.val)
  store <2 x half> %r.val, <2 x half> addrspace(1)* %r
  ret void
}

define amdgpu_ps <2 x half> @minnum_v2f16_no_ieee(<2 x half> %a, <2 x half> %b) #0 {
; SI-LABEL: minnum_v2f16_no_ieee:
; SI:       ; %bb.0:
; SI-NEXT:    v_cvt_f16_f32_e32 v3, v3
; SI-NEXT:    v_cvt_f16_f32_e32 v2, v2
; SI-NEXT:    v_cvt_f16_f32_e32 v0, v0
; SI-NEXT:    v_cvt_f16_f32_e32 v1, v1
; SI-NEXT:    v_cvt_f32_f16_e32 v3, v3
; SI-NEXT:    v_cvt_f32_f16_e32 v2, v2
; SI-NEXT:    v_cvt_f32_f16_e32 v0, v0
; SI-NEXT:    v_cvt_f32_f16_e32 v1, v1
; SI-NEXT:    v_min_f32_e32 v0, v0, v2
; SI-NEXT:    v_min_f32_e32 v1, v1, v3
; SI-NEXT:    ; return to shader part epilog
;
; VI-LABEL: minnum_v2f16_no_ieee:
; VI:       ; %bb.0:
; VI-NEXT:    v_min_f16_sdwa v2, v0, v1 dst_sel:WORD_1 dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; VI-NEXT:    v_min_f16_e32 v0, v0, v1
; VI-NEXT:    v_or_b32_e32 v0, v0, v2
; VI-NEXT:    ; return to shader part epilog
;
; GFX9-LABEL: minnum_v2f16_no_ieee:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    v_pk_min_f16 v0, v0, v1
; GFX9-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: minnum_v2f16_no_ieee:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    v_pk_min_f16 v0, v0, v1
; GFX10-NEXT:    ; return to shader part epilog
  %r.val = call <2 x half> @llvm.minnum.v2f16(<2 x half> %a, <2 x half> %b)
  ret <2 x half> %r.val
}

define amdgpu_kernel void @minnum_v2f16_imm_a(
; SI-LABEL: minnum_v2f16_imm_a:
; SI:       ; %bb.0: ; %entry
; SI-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x9
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    s_load_dword s2, s[2:3], 0x0
; SI-NEXT:    s_mov_b32 s3, 0xf000
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    v_cvt_f32_f16_e32 v0, s2
; SI-NEXT:    s_lshr_b32 s2, s2, 16
; SI-NEXT:    v_cvt_f32_f16_e32 v1, s2
; SI-NEXT:    s_mov_b32 s2, -1
; SI-NEXT:    v_mul_f32_e32 v0, 1.0, v0
; SI-NEXT:    v_min_f32_e32 v0, 0x40400000, v0
; SI-NEXT:    v_mul_f32_e32 v1, 1.0, v1
; SI-NEXT:    v_min_f32_e32 v1, 4.0, v1
; SI-NEXT:    v_cvt_f16_f32_e32 v1, v1
; SI-NEXT:    v_cvt_f16_f32_e32 v0, v0
; SI-NEXT:    v_lshlrev_b32_e32 v1, 16, v1
; SI-NEXT:    v_or_b32_e32 v0, v0, v1
; SI-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; SI-NEXT:    s_endpgm
;
; VI-LABEL: minnum_v2f16_imm_a:
; VI:       ; %bb.0: ; %entry
; VI-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x24
; VI-NEXT:    v_mov_b32_e32 v2, 0x4400
; VI-NEXT:    s_mov_b32 s3, 0xf000
; VI-NEXT:    s_mov_b32 s2, -1
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    s_mov_b32 s0, s4
; VI-NEXT:    s_load_dword s4, s[6:7], 0x0
; VI-NEXT:    s_mov_b32 s1, s5
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    v_max_f16_e64 v0, s4, s4
; VI-NEXT:    s_lshr_b32 s4, s4, 16
; VI-NEXT:    v_max_f16_e64 v1, s4, s4
; VI-NEXT:    v_min_f16_e32 v0, 0x4200, v0
; VI-NEXT:    v_min_f16_sdwa v1, v1, v2 dst_sel:WORD_1 dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:DWORD
; VI-NEXT:    v_or_b32_e32 v0, v0, v1
; VI-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; VI-NEXT:    s_endpgm
;
; GFX9-LABEL: minnum_v2f16_imm_a:
; GFX9:       ; %bb.0: ; %entry
; GFX9-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x24
; GFX9-NEXT:    s_mov_b32 s7, 0xf000
; GFX9-NEXT:    s_mov_b32 s6, -1
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    s_load_dword s2, s[2:3], 0x0
; GFX9-NEXT:    s_mov_b32 s4, s0
; GFX9-NEXT:    s_mov_b32 s0, 0x44004200
; GFX9-NEXT:    s_mov_b32 s5, s1
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    v_pk_max_f16 v0, s2, s2
; GFX9-NEXT:    v_pk_min_f16 v0, v0, s0
; GFX9-NEXT:    buffer_store_dword v0, off, s[4:7], 0
; GFX9-NEXT:    s_endpgm
;
; GFX10-LABEL: minnum_v2f16_imm_a:
; GFX10:       ; %bb.0: ; %entry
; GFX10-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x24
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    s_load_dword s2, s[2:3], 0x0
; GFX10-NEXT:    s_mov_b32 s3, 0x31016000
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    v_pk_max_f16 v0, s2, s2
; GFX10-NEXT:    s_mov_b32 s2, -1
; GFX10-NEXT:    v_pk_min_f16 v0, 0x44004200, v0
; GFX10-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; GFX10-NEXT:    s_endpgm
    <2 x half> addrspace(1)* %r,
    <2 x half> addrspace(1)* %b) #0 {
entry:
  %b.val = load <2 x half>, <2 x half> addrspace(1)* %b
  %r.val = call <2 x half> @llvm.minnum.v2f16(<2 x half> <half 3.0, half 4.0>, <2 x half> %b.val)
  store <2 x half> %r.val, <2 x half> addrspace(1)* %r
  ret void
}

define amdgpu_kernel void @minnum_v2f16_imm_b(
; SI-LABEL: minnum_v2f16_imm_b:
; SI:       ; %bb.0: ; %entry
; SI-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x9
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    s_load_dword s2, s[2:3], 0x0
; SI-NEXT:    s_mov_b32 s3, 0xf000
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    v_cvt_f32_f16_e32 v0, s2
; SI-NEXT:    s_lshr_b32 s2, s2, 16
; SI-NEXT:    v_cvt_f32_f16_e32 v1, s2
; SI-NEXT:    s_mov_b32 s2, -1
; SI-NEXT:    v_mul_f32_e32 v0, 1.0, v0
; SI-NEXT:    v_min_f32_e32 v0, 4.0, v0
; SI-NEXT:    v_mul_f32_e32 v1, 1.0, v1
; SI-NEXT:    v_min_f32_e32 v1, 0x40400000, v1
; SI-NEXT:    v_cvt_f16_f32_e32 v1, v1
; SI-NEXT:    v_cvt_f16_f32_e32 v0, v0
; SI-NEXT:    v_lshlrev_b32_e32 v1, 16, v1
; SI-NEXT:    v_or_b32_e32 v0, v0, v1
; SI-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; SI-NEXT:    s_endpgm
;
; VI-LABEL: minnum_v2f16_imm_b:
; VI:       ; %bb.0: ; %entry
; VI-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x24
; VI-NEXT:    v_mov_b32_e32 v2, 0x4200
; VI-NEXT:    s_mov_b32 s3, 0xf000
; VI-NEXT:    s_mov_b32 s2, -1
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    s_mov_b32 s0, s4
; VI-NEXT:    s_load_dword s4, s[6:7], 0x0
; VI-NEXT:    s_mov_b32 s1, s5
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    v_max_f16_e64 v0, s4, s4
; VI-NEXT:    s_lshr_b32 s4, s4, 16
; VI-NEXT:    v_max_f16_e64 v1, s4, s4
; VI-NEXT:    v_min_f16_e32 v0, 4.0, v0
; VI-NEXT:    v_min_f16_sdwa v1, v1, v2 dst_sel:WORD_1 dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:DWORD
; VI-NEXT:    v_or_b32_e32 v0, v0, v1
; VI-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; VI-NEXT:    s_endpgm
;
; GFX9-LABEL: minnum_v2f16_imm_b:
; GFX9:       ; %bb.0: ; %entry
; GFX9-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x24
; GFX9-NEXT:    s_mov_b32 s7, 0xf000
; GFX9-NEXT:    s_mov_b32 s6, -1
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    s_load_dword s2, s[2:3], 0x0
; GFX9-NEXT:    s_mov_b32 s4, s0
; GFX9-NEXT:    s_mov_b32 s0, 0x42004400
; GFX9-NEXT:    s_mov_b32 s5, s1
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    v_pk_max_f16 v0, s2, s2
; GFX9-NEXT:    v_pk_min_f16 v0, v0, s0
; GFX9-NEXT:    buffer_store_dword v0, off, s[4:7], 0
; GFX9-NEXT:    s_endpgm
;
; GFX10-LABEL: minnum_v2f16_imm_b:
; GFX10:       ; %bb.0: ; %entry
; GFX10-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x24
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    s_load_dword s2, s[2:3], 0x0
; GFX10-NEXT:    s_mov_b32 s3, 0x31016000
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    v_pk_max_f16 v0, s2, s2
; GFX10-NEXT:    s_mov_b32 s2, -1
; GFX10-NEXT:    v_pk_min_f16 v0, 0x42004400, v0
; GFX10-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; GFX10-NEXT:    s_endpgm
    <2 x half> addrspace(1)* %r,
    <2 x half> addrspace(1)* %a) #0 {
entry:
  %a.val = load <2 x half>, <2 x half> addrspace(1)* %a
  %r.val = call <2 x half> @llvm.minnum.v2f16(<2 x half> %a.val, <2 x half> <half 4.0, half 3.0>)
  store <2 x half> %r.val, <2 x half> addrspace(1)* %r
  ret void
}

; FIXME: Scalarize with undef half
define amdgpu_kernel void @minnum_v3f16(
; SI-LABEL: minnum_v3f16:
; SI:       ; %bb.0: ; %entry
; SI-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x9
; SI-NEXT:    s_load_dwordx2 s[8:9], s[0:1], 0xd
; SI-NEXT:    s_mov_b32 s3, 0xf000
; SI-NEXT:    s_mov_b32 s2, -1
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    s_mov_b32 s0, s4
; SI-NEXT:    s_load_dwordx2 s[6:7], s[6:7], 0x0
; SI-NEXT:    s_load_dwordx2 s[8:9], s[8:9], 0x0
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    s_lshr_b32 s1, s6, 16
; SI-NEXT:    s_lshr_b32 s4, s8, 16
; SI-NEXT:    v_cvt_f32_f16_e32 v3, s1
; SI-NEXT:    v_cvt_f32_f16_e32 v2, s4
; SI-NEXT:    v_cvt_f32_f16_e32 v1, s6
; SI-NEXT:    v_cvt_f32_f16_e32 v5, s8
; SI-NEXT:    v_cvt_f32_f16_e32 v0, s7
; SI-NEXT:    v_cvt_f32_f16_e32 v4, s9
; SI-NEXT:    v_mul_f32_e32 v2, 1.0, v2
; SI-NEXT:    v_mul_f32_e32 v3, 1.0, v3
; SI-NEXT:    v_min_f32_e32 v2, v3, v2
; SI-NEXT:    v_mul_f32_e32 v3, 1.0, v5
; SI-NEXT:    v_mul_f32_e32 v1, 1.0, v1
; SI-NEXT:    v_min_f32_e32 v1, v1, v3
; SI-NEXT:    v_mul_f32_e32 v3, 1.0, v4
; SI-NEXT:    v_mul_f32_e32 v0, 1.0, v0
; SI-NEXT:    v_cvt_f16_f32_e32 v2, v2
; SI-NEXT:    v_min_f32_e32 v0, v0, v3
; SI-NEXT:    v_cvt_f16_f32_e32 v1, v1
; SI-NEXT:    v_cvt_f16_f32_e32 v0, v0
; SI-NEXT:    v_lshlrev_b32_e32 v2, 16, v2
; SI-NEXT:    s_mov_b32 s1, s5
; SI-NEXT:    v_or_b32_e32 v1, v1, v2
; SI-NEXT:    buffer_store_short v0, off, s[0:3], 0 offset:4
; SI-NEXT:    buffer_store_dword v1, off, s[0:3], 0
; SI-NEXT:    s_endpgm
;
; VI-LABEL: minnum_v3f16:
; VI:       ; %bb.0: ; %entry
; VI-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x24
; VI-NEXT:    s_load_dwordx2 s[8:9], s[0:1], 0x34
; VI-NEXT:    s_mov_b32 s3, 0xf000
; VI-NEXT:    s_mov_b32 s2, -1
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    s_mov_b32 s0, s4
; VI-NEXT:    s_mov_b32 s1, s5
; VI-NEXT:    s_load_dwordx2 s[4:5], s[6:7], 0x0
; VI-NEXT:    s_load_dwordx2 s[6:7], s[8:9], 0x0
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    v_max_f16_e64 v1, s4, s4
; VI-NEXT:    v_max_f16_e64 v0, s6, s6
; VI-NEXT:    s_lshr_b32 s4, s4, 16
; VI-NEXT:    s_lshr_b32 s6, s6, 16
; VI-NEXT:    v_min_f16_e32 v0, v1, v0
; VI-NEXT:    v_max_f16_e64 v1, s6, s6
; VI-NEXT:    v_max_f16_e64 v2, s4, s4
; VI-NEXT:    v_min_f16_sdwa v1, v2, v1 dst_sel:WORD_1 dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:DWORD
; VI-NEXT:    v_or_b32_e32 v0, v0, v1
; VI-NEXT:    v_max_f16_e64 v1, s7, s7
; VI-NEXT:    v_max_f16_e64 v2, s5, s5
; VI-NEXT:    v_min_f16_e32 v1, v2, v1
; VI-NEXT:    buffer_store_short v1, off, s[0:3], 0 offset:4
; VI-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; VI-NEXT:    s_endpgm
;
; GFX9-LABEL: minnum_v3f16:
; GFX9:       ; %bb.0: ; %entry
; GFX9-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x24
; GFX9-NEXT:    s_load_dwordx2 s[8:9], s[0:1], 0x34
; GFX9-NEXT:    s_mov_b32 s3, 0xf000
; GFX9-NEXT:    s_mov_b32 s2, -1
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    s_mov_b32 s0, s4
; GFX9-NEXT:    s_mov_b32 s1, s5
; GFX9-NEXT:    s_load_dwordx2 s[4:5], s[6:7], 0x0
; GFX9-NEXT:    s_load_dwordx2 s[10:11], s[8:9], 0x0
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    v_pk_max_f16 v1, s4, s4
; GFX9-NEXT:    v_pk_max_f16 v0, s10, s10
; GFX9-NEXT:    v_pk_min_f16 v0, v1, v0
; GFX9-NEXT:    v_pk_max_f16 v2, s11, s11
; GFX9-NEXT:    v_pk_max_f16 v1, s5, s5
; GFX9-NEXT:    v_pk_min_f16 v1, v1, v2
; GFX9-NEXT:    buffer_store_short v1, off, s[0:3], 0 offset:4
; GFX9-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; GFX9-NEXT:    s_endpgm
;
; GFX10-LABEL: minnum_v3f16:
; GFX10:       ; %bb.0: ; %entry
; GFX10-NEXT:    s_clause 0x1
; GFX10-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0x34
; GFX10-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x24
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    s_load_dwordx2 s[0:1], s[2:3], 0x0
; GFX10-NEXT:    s_load_dwordx2 s[8:9], s[6:7], 0x0
; GFX10-NEXT:    s_mov_b32 s7, 0x31016000
; GFX10-NEXT:    s_mov_b32 s6, -1
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    v_pk_max_f16 v1, s1, s1
; GFX10-NEXT:    v_pk_max_f16 v2, s9, s9
; GFX10-NEXT:    v_pk_max_f16 v0, s0, s0
; GFX10-NEXT:    v_pk_max_f16 v3, s8, s8
; GFX10-NEXT:    v_pk_min_f16 v1, v2, v1
; GFX10-NEXT:    v_pk_min_f16 v0, v3, v0
; GFX10-NEXT:    buffer_store_short v1, off, s[4:7], 0 offset:4
; GFX10-NEXT:    buffer_store_dword v0, off, s[4:7], 0
; GFX10-NEXT:    s_endpgm
    <3 x half> addrspace(1)* %r,
    <3 x half> addrspace(1)* %a,
    <3 x half> addrspace(1)* %b) #0 {
entry:
  %a.val = load <3 x half>, <3 x half> addrspace(1)* %a
  %b.val = load <3 x half>, <3 x half> addrspace(1)* %b
  %r.val = call <3 x half> @llvm.minnum.v3f16(<3 x half> %a.val, <3 x half> %b.val)
  store <3 x half> %r.val, <3 x half> addrspace(1)* %r
  ret void
}

define amdgpu_kernel void @minnum_v4f16(
; SI-LABEL: minnum_v4f16:
; SI:       ; %bb.0: ; %entry
; SI-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x9
; SI-NEXT:    s_load_dwordx2 s[8:9], s[0:1], 0xd
; SI-NEXT:    s_mov_b32 s3, 0xf000
; SI-NEXT:    s_mov_b32 s2, -1
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    s_mov_b32 s0, s4
; SI-NEXT:    s_mov_b32 s1, s5
; SI-NEXT:    s_load_dwordx2 s[4:5], s[6:7], 0x0
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    v_cvt_f32_f16_e32 v0, s4
; SI-NEXT:    v_cvt_f32_f16_e32 v1, s5
; SI-NEXT:    s_lshr_b32 s4, s4, 16
; SI-NEXT:    s_lshr_b32 s5, s5, 16
; SI-NEXT:    v_cvt_f32_f16_e32 v2, s4
; SI-NEXT:    v_cvt_f32_f16_e32 v3, s5
; SI-NEXT:    s_load_dwordx2 s[4:5], s[8:9], 0x0
; SI-NEXT:    v_mul_f32_e32 v1, 1.0, v1
; SI-NEXT:    v_mul_f32_e32 v2, 1.0, v2
; SI-NEXT:    v_mul_f32_e32 v3, 1.0, v3
; SI-NEXT:    v_mul_f32_e32 v0, 1.0, v0
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    s_lshr_b32 s6, s5, 16
; SI-NEXT:    v_cvt_f32_f16_e32 v5, s6
; SI-NEXT:    v_cvt_f32_f16_e32 v4, s4
; SI-NEXT:    s_lshr_b32 s4, s4, 16
; SI-NEXT:    v_cvt_f32_f16_e32 v7, s5
; SI-NEXT:    v_cvt_f32_f16_e32 v6, s4
; SI-NEXT:    v_mul_f32_e32 v5, 1.0, v5
; SI-NEXT:    v_min_f32_e32 v3, v3, v5
; SI-NEXT:    v_mul_f32_e32 v5, 1.0, v7
; SI-NEXT:    v_min_f32_e32 v1, v1, v5
; SI-NEXT:    v_mul_f32_e32 v5, 1.0, v6
; SI-NEXT:    v_min_f32_e32 v2, v2, v5
; SI-NEXT:    v_mul_f32_e32 v4, 1.0, v4
; SI-NEXT:    v_cvt_f16_f32_e32 v3, v3
; SI-NEXT:    v_cvt_f16_f32_e32 v2, v2
; SI-NEXT:    v_min_f32_e32 v0, v0, v4
; SI-NEXT:    v_cvt_f16_f32_e32 v1, v1
; SI-NEXT:    v_cvt_f16_f32_e32 v0, v0
; SI-NEXT:    v_lshlrev_b32_e32 v3, 16, v3
; SI-NEXT:    v_lshlrev_b32_e32 v2, 16, v2
; SI-NEXT:    v_or_b32_e32 v1, v1, v3
; SI-NEXT:    v_or_b32_e32 v0, v0, v2
; SI-NEXT:    buffer_store_dwordx2 v[0:1], off, s[0:3], 0
; SI-NEXT:    s_endpgm
;
; VI-LABEL: minnum_v4f16:
; VI:       ; %bb.0: ; %entry
; VI-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x24
; VI-NEXT:    s_load_dwordx2 s[8:9], s[0:1], 0x34
; VI-NEXT:    s_mov_b32 s3, 0xf000
; VI-NEXT:    s_mov_b32 s2, -1
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    s_mov_b32 s0, s4
; VI-NEXT:    s_mov_b32 s1, s5
; VI-NEXT:    s_load_dwordx2 s[4:5], s[6:7], 0x0
; VI-NEXT:    s_load_dwordx2 s[6:7], s[8:9], 0x0
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    v_max_f16_e64 v1, s5, s5
; VI-NEXT:    v_max_f16_e64 v0, s7, s7
; VI-NEXT:    s_lshr_b32 s5, s5, 16
; VI-NEXT:    s_lshr_b32 s7, s7, 16
; VI-NEXT:    v_min_f16_e32 v0, v1, v0
; VI-NEXT:    v_max_f16_e64 v2, s5, s5
; VI-NEXT:    v_max_f16_e64 v1, s7, s7
; VI-NEXT:    v_min_f16_sdwa v1, v2, v1 dst_sel:WORD_1 dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:DWORD
; VI-NEXT:    v_or_b32_e32 v1, v0, v1
; VI-NEXT:    v_max_f16_e64 v2, s4, s4
; VI-NEXT:    v_max_f16_e64 v0, s6, s6
; VI-NEXT:    s_lshr_b32 s4, s4, 16
; VI-NEXT:    s_lshr_b32 s5, s6, 16
; VI-NEXT:    v_min_f16_e32 v0, v2, v0
; VI-NEXT:    v_max_f16_e64 v2, s5, s5
; VI-NEXT:    v_max_f16_e64 v3, s4, s4
; VI-NEXT:    v_min_f16_sdwa v2, v3, v2 dst_sel:WORD_1 dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:DWORD
; VI-NEXT:    v_or_b32_e32 v0, v0, v2
; VI-NEXT:    buffer_store_dwordx2 v[0:1], off, s[0:3], 0
; VI-NEXT:    s_endpgm
;
; GFX9-LABEL: minnum_v4f16:
; GFX9:       ; %bb.0: ; %entry
; GFX9-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x24
; GFX9-NEXT:    s_load_dwordx2 s[8:9], s[0:1], 0x34
; GFX9-NEXT:    s_mov_b32 s3, 0xf000
; GFX9-NEXT:    s_mov_b32 s2, -1
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    s_mov_b32 s0, s4
; GFX9-NEXT:    s_mov_b32 s1, s5
; GFX9-NEXT:    s_load_dwordx2 s[4:5], s[6:7], 0x0
; GFX9-NEXT:    s_load_dwordx2 s[10:11], s[8:9], 0x0
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    v_pk_max_f16 v1, s5, s5
; GFX9-NEXT:    v_pk_max_f16 v0, s11, s11
; GFX9-NEXT:    v_pk_min_f16 v1, v1, v0
; GFX9-NEXT:    v_pk_max_f16 v2, s10, s10
; GFX9-NEXT:    v_pk_max_f16 v0, s4, s4
; GFX9-NEXT:    v_pk_min_f16 v0, v0, v2
; GFX9-NEXT:    buffer_store_dwordx2 v[0:1], off, s[0:3], 0
; GFX9-NEXT:    s_endpgm
;
; GFX10-LABEL: minnum_v4f16:
; GFX10:       ; %bb.0: ; %entry
; GFX10-NEXT:    s_clause 0x1
; GFX10-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0x34
; GFX10-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x24
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    s_load_dwordx2 s[0:1], s[2:3], 0x0
; GFX10-NEXT:    s_load_dwordx2 s[8:9], s[6:7], 0x0
; GFX10-NEXT:    s_mov_b32 s7, 0x31016000
; GFX10-NEXT:    s_mov_b32 s6, -1
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    v_pk_max_f16 v0, s1, s1
; GFX10-NEXT:    v_pk_max_f16 v1, s9, s9
; GFX10-NEXT:    v_pk_max_f16 v2, s0, s0
; GFX10-NEXT:    v_pk_max_f16 v3, s8, s8
; GFX10-NEXT:    v_pk_min_f16 v1, v1, v0
; GFX10-NEXT:    v_pk_min_f16 v0, v3, v2
; GFX10-NEXT:    buffer_store_dwordx2 v[0:1], off, s[4:7], 0
; GFX10-NEXT:    s_endpgm
    <4 x half> addrspace(1)* %r,
    <4 x half> addrspace(1)* %a,
    <4 x half> addrspace(1)* %b) #0 {
entry:
  %a.val = load <4 x half>, <4 x half> addrspace(1)* %a
  %b.val = load <4 x half>, <4 x half> addrspace(1)* %b
  %r.val = call <4 x half> @llvm.minnum.v4f16(<4 x half> %a.val, <4 x half> %b.val)
  store <4 x half> %r.val, <4 x half> addrspace(1)* %r
  ret void
}

define amdgpu_kernel void @fmin_v4f16_imm_a(
; SI-LABEL: fmin_v4f16_imm_a:
; SI:       ; %bb.0: ; %entry
; SI-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x9
; SI-NEXT:    s_mov_b32 s3, 0xf000
; SI-NEXT:    s_mov_b32 s2, -1
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    s_mov_b32 s0, s4
; SI-NEXT:    s_mov_b32 s1, s5
; SI-NEXT:    s_load_dwordx2 s[4:5], s[6:7], 0x0
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    v_cvt_f32_f16_e32 v1, s5
; SI-NEXT:    s_lshr_b32 s5, s5, 16
; SI-NEXT:    v_cvt_f32_f16_e32 v0, s4
; SI-NEXT:    v_cvt_f32_f16_e32 v2, s5
; SI-NEXT:    s_lshr_b32 s4, s4, 16
; SI-NEXT:    v_cvt_f32_f16_e32 v3, s4
; SI-NEXT:    v_mul_f32_e32 v1, 1.0, v1
; SI-NEXT:    v_mul_f32_e32 v2, 1.0, v2
; SI-NEXT:    v_min_f32_e32 v2, 4.0, v2
; SI-NEXT:    v_mul_f32_e32 v3, 1.0, v3
; SI-NEXT:    v_min_f32_e32 v1, 0x40400000, v1
; SI-NEXT:    v_cvt_f16_f32_e32 v2, v2
; SI-NEXT:    v_min_f32_e32 v3, 2.0, v3
; SI-NEXT:    v_mul_f32_e32 v0, 1.0, v0
; SI-NEXT:    v_min_f32_e32 v0, 0x41000000, v0
; SI-NEXT:    v_cvt_f16_f32_e32 v1, v1
; SI-NEXT:    v_cvt_f16_f32_e32 v3, v3
; SI-NEXT:    v_cvt_f16_f32_e32 v0, v0
; SI-NEXT:    v_lshlrev_b32_e32 v2, 16, v2
; SI-NEXT:    v_or_b32_e32 v1, v1, v2
; SI-NEXT:    v_lshlrev_b32_e32 v2, 16, v3
; SI-NEXT:    v_or_b32_e32 v0, v0, v2
; SI-NEXT:    buffer_store_dwordx2 v[0:1], off, s[0:3], 0
; SI-NEXT:    s_endpgm
;
; VI-LABEL: fmin_v4f16_imm_a:
; VI:       ; %bb.0: ; %entry
; VI-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x24
; VI-NEXT:    v_mov_b32_e32 v0, 0x4400
; VI-NEXT:    s_mov_b32 s3, 0xf000
; VI-NEXT:    s_mov_b32 s2, -1
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    s_mov_b32 s0, s4
; VI-NEXT:    s_mov_b32 s1, s5
; VI-NEXT:    s_load_dwordx2 s[4:5], s[6:7], 0x0
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    v_max_f16_e64 v1, s5, s5
; VI-NEXT:    s_lshr_b32 s5, s5, 16
; VI-NEXT:    v_max_f16_e64 v3, s5, s5
; VI-NEXT:    v_max_f16_e64 v2, s4, s4
; VI-NEXT:    v_min_f16_sdwa v0, v3, v0 dst_sel:WORD_1 dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:DWORD
; VI-NEXT:    v_min_f16_e32 v1, 0x4200, v1
; VI-NEXT:    s_lshr_b32 s4, s4, 16
; VI-NEXT:    v_or_b32_e32 v1, v1, v0
; VI-NEXT:    v_min_f16_e32 v0, 0x4800, v2
; VI-NEXT:    v_max_f16_e64 v2, s4, s4
; VI-NEXT:    v_mov_b32_e32 v3, 0x4000
; VI-NEXT:    v_min_f16_sdwa v2, v2, v3 dst_sel:WORD_1 dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:DWORD
; VI-NEXT:    v_or_b32_e32 v0, v0, v2
; VI-NEXT:    buffer_store_dwordx2 v[0:1], off, s[0:3], 0
; VI-NEXT:    s_endpgm
;
; GFX9-LABEL: fmin_v4f16_imm_a:
; GFX9:       ; %bb.0: ; %entry
; GFX9-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x24
; GFX9-NEXT:    s_mov_b32 s8, 0x44004200
; GFX9-NEXT:    s_mov_b32 s9, 0x40004800
; GFX9-NEXT:    s_mov_b32 s3, 0xf000
; GFX9-NEXT:    s_mov_b32 s2, -1
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    s_load_dwordx2 s[6:7], s[6:7], 0x0
; GFX9-NEXT:    s_mov_b32 s0, s4
; GFX9-NEXT:    s_mov_b32 s1, s5
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    v_pk_max_f16 v0, s7, s7
; GFX9-NEXT:    v_pk_max_f16 v2, s6, s6
; GFX9-NEXT:    v_pk_min_f16 v1, v0, s8
; GFX9-NEXT:    v_pk_min_f16 v0, v2, s9
; GFX9-NEXT:    buffer_store_dwordx2 v[0:1], off, s[0:3], 0
; GFX9-NEXT:    s_endpgm
;
; GFX10-LABEL: fmin_v4f16_imm_a:
; GFX10:       ; %bb.0: ; %entry
; GFX10-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x24
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    s_load_dwordx2 s[2:3], s[2:3], 0x0
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    v_pk_max_f16 v0, s3, s3
; GFX10-NEXT:    v_pk_max_f16 v2, s2, s2
; GFX10-NEXT:    s_mov_b32 s3, 0x31016000
; GFX10-NEXT:    s_mov_b32 s2, -1
; GFX10-NEXT:    v_pk_min_f16 v1, 0x44004200, v0
; GFX10-NEXT:    v_pk_min_f16 v0, 0x40004800, v2
; GFX10-NEXT:    buffer_store_dwordx2 v[0:1], off, s[0:3], 0
; GFX10-NEXT:    s_endpgm
    <4 x half> addrspace(1)* %r,
    <4 x half> addrspace(1)* %b) #0 {
entry:
  %b.val = load <4 x half>, <4 x half> addrspace(1)* %b
  %r.val = call <4 x half> @llvm.minnum.v4f16(<4 x half> <half 8.0, half 2.0, half 3.0, half 4.0>, <4 x half> %b.val)
  store <4 x half> %r.val, <4 x half> addrspace(1)* %r
  ret void
}

attributes #0 = { "denormal-fp-math-f32"="preserve-sign,preserve-sign" }
