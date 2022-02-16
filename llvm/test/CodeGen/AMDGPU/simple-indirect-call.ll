; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --check-globals
; RUN: opt -S -mtriple=amdgcn-amd-amdhsa -amdgpu-annotate-kernel-features  %s | FileCheck -check-prefixes=GCN,AKF_GCN %s
; RUN: opt -S -mtriple=amdgcn-amd-amdhsa -amdgpu-attributor %s | FileCheck -check-prefixes=GCN,ATTRIBUTOR_GCN %s

; RUN: llc -mtriple=amdgcn-amd-amdhsa -mcpu=gfx900 < %s | FileCheck -check-prefix=GFX9 %s

target datalayout = "A5"

; GFX9-LABEL: {{^}}indirect:
define internal void @indirect() {
; GCN-LABEL: define {{[^@]+}}@indirect
; GCN-SAME: () #[[ATTR0:[0-9]+]] {
; GCN-NEXT:    ret void
;
  ret void
}

; GFX9-LABEL: {{^}}test_simple_indirect_call:
; GFX9:  s_add_u32 flat_scratch_lo, s12, s17
; GFX9-NEXT:  s_addc_u32 flat_scratch_hi, s13, 0
; GFX9-NEXT:  s_mov_b32 s13, s15
; GFX9-NEXT:  s_mov_b32 s12, s14
; GFX9-NEXT:  s_load_dwordx2 s[14:15], s[4:5], 0x4
; GFX9-NEXT:  s_add_u32 s0, s0, s17
; GFX9-NEXT:  s_addc_u32 s1, s1, 0
; GFX9-NEXT:  s_mov_b32 s32, 0
; GFX9-NEXT:  s_waitcnt lgkmcnt(0)
; GFX9-NEXT:  s_lshr_b32 s14, s14, 16
; GFX9-NEXT:  s_mul_i32 s14, s14, s15
; GFX9-NEXT:  v_mul_lo_u32 v3, s14, v0
; GFX9-NEXT:  s_getpc_b64 s[18:19]
; GFX9-NEXT:  s_add_u32 s18, s18, indirect@rel32@lo+4
; GFX9-NEXT:  s_addc_u32 s19, s19, indirect@rel32@hi+12
; GFX9-NEXT:  s_mov_b32 s14, s16
; GFX9-NEXT:  v_mad_u32_u24 v3, v1, s15, v3
; GFX9-NEXT:  v_add_lshl_u32 v5, v3, v2, 3
; GFX9-NEXT:  v_mov_b32_e32 v3, s18
; GFX9-NEXT:  v_lshlrev_b32_e32 v2, 20, v2
; GFX9-NEXT:  v_lshlrev_b32_e32 v1, 10, v1
; GFX9-NEXT:  v_mov_b32_e32 v4, s19
; GFX9-NEXT:  v_or3_b32 v0, v0, v1, v2
; GFX9-NEXT:  ds_write_b64 v5, v[3:4]
; GFX9-NEXT:  s_swappc_b64 s[30:31], s[18:19]
; GFX9-NEXT:  s_endpgm
define amdgpu_kernel void @test_simple_indirect_call() {
; AKF_GCN-LABEL: define {{[^@]+}}@test_simple_indirect_call
; AKF_GCN-SAME: () #[[ATTR1:[0-9]+]] {
; AKF_GCN-NEXT:    [[FPTR:%.*]] = alloca void ()*, align 8, addrspace(5)
; AKF_GCN-NEXT:    [[FPTR_CAST:%.*]] = addrspacecast void ()* addrspace(5)* [[FPTR]] to void ()**
; AKF_GCN-NEXT:    store void ()* @indirect, void ()** [[FPTR_CAST]], align 8
; AKF_GCN-NEXT:    [[FP:%.*]] = load void ()*, void ()** [[FPTR_CAST]], align 8
; AKF_GCN-NEXT:    call void [[FP]]()
; AKF_GCN-NEXT:    ret void
;
; ATTRIBUTOR_GCN-LABEL: define {{[^@]+}}@test_simple_indirect_call
; ATTRIBUTOR_GCN-SAME: () #[[ATTR1:[0-9]+]] {
; ATTRIBUTOR_GCN-NEXT:    call void @indirect()
; ATTRIBUTOR_GCN-NEXT:    ret void
;
  %fptr = alloca void()*, addrspace(5)
  %fptr.cast = addrspacecast void()* addrspace(5)* %fptr to void()**
  store void()* @indirect, void()** %fptr.cast
  %fp = load void()*, void()** %fptr.cast
  call void %fp()
  ret void
}

;.
; AKF_GCN: attributes #[[ATTR0]] = { "amdgpu-dispatch-id" "amdgpu-dispatch-ptr" "amdgpu-implicitarg-ptr" "amdgpu-queue-ptr" "amdgpu-work-group-id-x" "amdgpu-work-group-id-y" "amdgpu-work-group-id-z" "amdgpu-work-item-id-x" "amdgpu-work-item-id-y" "amdgpu-work-item-id-z" }
; AKF_GCN: attributes #[[ATTR1]] = { "amdgpu-calls" "amdgpu-dispatch-id" "amdgpu-dispatch-ptr" "amdgpu-implicitarg-ptr" "amdgpu-queue-ptr" "amdgpu-stack-objects" "amdgpu-work-group-id-x" "amdgpu-work-group-id-y" "amdgpu-work-group-id-z" "amdgpu-work-item-id-x" "amdgpu-work-item-id-y" "amdgpu-work-item-id-z" }
;.
; ATTRIBUTOR_GCN: attributes #[[ATTR0]] = { "amdgpu-dispatch-id" "amdgpu-dispatch-ptr" "amdgpu-implicitarg-ptr" "amdgpu-queue-ptr" "amdgpu-work-group-id-x" "amdgpu-work-group-id-y" "amdgpu-work-group-id-z" "amdgpu-work-item-id-x" "amdgpu-work-item-id-y" "amdgpu-work-item-id-z" "uniform-work-group-size"="false" }
; ATTRIBUTOR_GCN: attributes #[[ATTR1]] = { "amdgpu-calls" "amdgpu-dispatch-id" "amdgpu-dispatch-ptr" "amdgpu-implicitarg-ptr" "amdgpu-queue-ptr" "amdgpu-stack-objects" "amdgpu-work-group-id-x" "amdgpu-work-group-id-y" "amdgpu-work-group-id-z" "amdgpu-work-item-id-x" "amdgpu-work-item-id-y" "amdgpu-work-item-id-z" "uniform-work-group-size"="false" }
;.
