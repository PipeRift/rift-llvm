; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -mtriple=amdgcn-amd-amdhsa -S -amdgpu-aa-wrapper -amdgpu-aa -instcombine -o - %s | FileCheck %s

; Make sure the optimization from memcpy-from-global.ll happens, but
; the constant source is not a global variable.

target datalayout = "e-p:64:64-p1:64:64-p2:32:32-p3:32:32-p4:64:64-p5:32:32-p6:32:32-i64:64-v16:16-v24:32-v32:32-v48:64-v96:128-v192:256-v256:256-v512:512-v1024:1024-v2048:2048-n32:64-S32-A5"

; Simple memcpy to alloca from constant address space argument.
define i8 @memcpy_constant_arg_ptr_to_alloca([32 x i8] addrspace(4)* noalias readonly align 4 dereferenceable(32) %arg, i32 %idx) {
; CHECK-LABEL: @memcpy_constant_arg_ptr_to_alloca(
; CHECK-NEXT:    [[TMP1:%.*]] = sext i32 [[IDX:%.*]] to i64
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr [32 x i8], [32 x i8] addrspace(4)* [[ARG:%.*]], i64 0, i64 [[TMP1]]
; CHECK-NEXT:    [[LOAD:%.*]] = load i8, i8 addrspace(4)* [[GEP]], align 1
; CHECK-NEXT:    ret i8 [[LOAD]]
;
  %alloca = alloca [32 x i8], align 4, addrspace(5)
  %alloca.cast = bitcast [32 x i8] addrspace(5)* %alloca to i8 addrspace(5)*
  %arg.cast = bitcast [32 x i8] addrspace(4)* %arg to i8 addrspace(4)*
  call void @llvm.memcpy.p5i8.p4i8.i64(i8 addrspace(5)* %alloca.cast, i8 addrspace(4)* %arg.cast, i64 32, i1 false)
  %gep = getelementptr inbounds [32 x i8], [32 x i8] addrspace(5)* %alloca, i32 0, i32 %idx
  %load = load i8, i8 addrspace(5)* %gep
  ret i8 %load
}

define i8 @memcpy_constant_arg_ptr_to_alloca_load_metadata([32 x i8] addrspace(4)* noalias readonly align 4 dereferenceable(32) %arg, i32 %idx) {
; CHECK-LABEL: @memcpy_constant_arg_ptr_to_alloca_load_metadata(
; CHECK-NEXT:    [[TMP1:%.*]] = sext i32 [[IDX:%.*]] to i64
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr [32 x i8], [32 x i8] addrspace(4)* [[ARG:%.*]], i64 0, i64 [[TMP1]]
; CHECK-NEXT:    [[LOAD:%.*]] = load i8, i8 addrspace(4)* [[GEP]], align 1, !noalias !0
; CHECK-NEXT:    ret i8 [[LOAD]]
;
  %alloca = alloca [32 x i8], align 4, addrspace(5)
  %alloca.cast = bitcast [32 x i8] addrspace(5)* %alloca to i8 addrspace(5)*
  %arg.cast = bitcast [32 x i8] addrspace(4)* %arg to i8 addrspace(4)*
  call void @llvm.memcpy.p5i8.p4i8.i64(i8 addrspace(5)* %alloca.cast, i8 addrspace(4)* %arg.cast, i64 32, i1 false)
  %gep = getelementptr inbounds [32 x i8], [32 x i8] addrspace(5)* %alloca, i32 0, i32 %idx
  %load = load i8, i8 addrspace(5)* %gep, !noalias !0
  ret i8 %load
}

define i64 @memcpy_constant_arg_ptr_to_alloca_load_alignment([32 x i64] addrspace(4)* noalias readonly align 4 dereferenceable(256) %arg, i32 %idx) {
; CHECK-LABEL: @memcpy_constant_arg_ptr_to_alloca_load_alignment(
; CHECK-NEXT:    [[TMP1:%.*]] = sext i32 [[IDX:%.*]] to i64
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr [32 x i64], [32 x i64] addrspace(4)* [[ARG:%.*]], i64 0, i64 [[TMP1]]
; CHECK-NEXT:    [[LOAD:%.*]] = load i64, i64 addrspace(4)* [[GEP]], align 16
; CHECK-NEXT:    ret i64 [[LOAD]]
;
  %alloca = alloca [32 x i64], align 4, addrspace(5)
  %alloca.cast = bitcast [32 x i64] addrspace(5)* %alloca to i8 addrspace(5)*
  %arg.cast = bitcast [32 x i64] addrspace(4)* %arg to i8 addrspace(4)*
  call void @llvm.memcpy.p5i8.p4i8.i64(i8 addrspace(5)* %alloca.cast, i8 addrspace(4)* %arg.cast, i64 256, i1 false)
  %gep = getelementptr inbounds [32 x i64], [32 x i64] addrspace(5)* %alloca, i32 0, i32 %idx
  %load = load i64, i64 addrspace(5)* %gep, align 16
  ret i64 %load
}

define i64 @memcpy_constant_arg_ptr_to_alloca_load_atomic([32 x i64] addrspace(4)* noalias readonly align 8 dereferenceable(256) %arg, i32 %idx) {
; CHECK-LABEL: @memcpy_constant_arg_ptr_to_alloca_load_atomic(
; CHECK-NEXT:    [[ALLOCA:%.*]] = alloca [32 x i64], align 8, addrspace(5)
; CHECK-NEXT:    [[ALLOCA_CAST:%.*]] = bitcast [32 x i64] addrspace(5)* [[ALLOCA]] to i8 addrspace(5)*
; CHECK-NEXT:    [[ARG_CAST:%.*]] = bitcast [32 x i64] addrspace(4)* [[ARG:%.*]] to i8 addrspace(4)*
; CHECK-NEXT:    call void @llvm.memcpy.p5i8.p4i8.i64(i8 addrspace(5)* noundef align 8 dereferenceable(256) [[ALLOCA_CAST]], i8 addrspace(4)* noundef align 8 dereferenceable(256) [[ARG_CAST]], i64 256, i1 false)
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr inbounds [32 x i64], [32 x i64] addrspace(5)* [[ALLOCA]], i32 0, i32 [[IDX:%.*]]
; CHECK-NEXT:    [[LOAD:%.*]] = load atomic i64, i64 addrspace(5)* [[GEP]] syncscope("somescope") acquire, align 8
; CHECK-NEXT:    ret i64 [[LOAD]]
;
  %alloca = alloca [32 x i64], align 8, addrspace(5)
  %alloca.cast = bitcast [32 x i64] addrspace(5)* %alloca to i8 addrspace(5)*
  %arg.cast = bitcast [32 x i64] addrspace(4)* %arg to i8 addrspace(4)*
  call void @llvm.memcpy.p5i8.p4i8.i64(i8 addrspace(5)* %alloca.cast, i8 addrspace(4)* %arg.cast, i64 256, i1 false)
  %gep = getelementptr inbounds [32 x i64], [32 x i64] addrspace(5)* %alloca, i32 0, i32 %idx
  %load = load atomic i64, i64 addrspace(5)* %gep syncscope("somescope") acquire, align 8
  ret i64 %load
}

; Simple memmove to alloca from constant address space argument.
define i8 @memmove_constant_arg_ptr_to_alloca([32 x i8] addrspace(4)* noalias readonly align 4 dereferenceable(32) %arg, i32 %idx) {
; CHECK-LABEL: @memmove_constant_arg_ptr_to_alloca(
; CHECK-NEXT:    [[TMP1:%.*]] = sext i32 [[IDX:%.*]] to i64
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr [32 x i8], [32 x i8] addrspace(4)* [[ARG:%.*]], i64 0, i64 [[TMP1]]
; CHECK-NEXT:    [[LOAD:%.*]] = load i8, i8 addrspace(4)* [[GEP]], align 1
; CHECK-NEXT:    ret i8 [[LOAD]]
;
  %alloca = alloca [32 x i8], align 4, addrspace(5)
  %alloca.cast = bitcast [32 x i8] addrspace(5)* %alloca to i8 addrspace(5)*
  %arg.cast = bitcast [32 x i8] addrspace(4)* %arg to i8 addrspace(4)*
  call void @llvm.memmove.p5i8.p4i8.i32(i8 addrspace(5)* %alloca.cast, i8 addrspace(4)* %arg.cast, i32 32, i1 false)
  %gep = getelementptr inbounds [32 x i8], [32 x i8] addrspace(5)* %alloca, i32 0, i32 %idx
  %load = load i8, i8 addrspace(5)* %gep
  ret i8 %load
}

; Simple memcpy to alloca from byref constant address space argument.
define amdgpu_kernel void @memcpy_constant_byref_arg_ptr_to_alloca([32 x i8] addrspace(4)* noalias readonly align 4 byref([32 x i8]) %arg, i8 addrspace(1)* %out, i32 %idx) {
; CHECK-LABEL: @memcpy_constant_byref_arg_ptr_to_alloca(
; CHECK-NEXT:    [[TMP1:%.*]] = sext i32 [[IDX:%.*]] to i64
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr [32 x i8], [32 x i8] addrspace(4)* [[ARG:%.*]], i64 0, i64 [[TMP1]]
; CHECK-NEXT:    [[LOAD:%.*]] = load i8, i8 addrspace(4)* [[GEP]], align 1
; CHECK-NEXT:    store i8 [[LOAD]], i8 addrspace(1)* [[OUT:%.*]], align 1
; CHECK-NEXT:    ret void
;
  %alloca = alloca [32 x i8], align 4, addrspace(5)
  %alloca.cast = bitcast [32 x i8] addrspace(5)* %alloca to i8 addrspace(5)*
  %arg.cast = bitcast [32 x i8] addrspace(4)* %arg to i8 addrspace(4)*
  call void @llvm.memcpy.p5i8.p4i8.i64(i8 addrspace(5)* %alloca.cast, i8 addrspace(4)* %arg.cast, i64 32, i1 false)
  %gep = getelementptr inbounds [32 x i8], [32 x i8] addrspace(5)* %alloca, i32 0, i32 %idx
  %load = load i8, i8 addrspace(5)* %gep
  store i8 %load, i8 addrspace(1)* %out
  ret void
}

; Simple memcpy to alloca from byref constant address space argument, but not enough bytes are dereferenceable
define amdgpu_kernel void @memcpy_constant_byref_arg_ptr_to_alloca_too_many_bytes([31 x i8] addrspace(4)* noalias readonly align 4 byref([31 x i8]) %arg, i8 addrspace(1)* %out, i32 %idx) {
; CHECK-LABEL: @memcpy_constant_byref_arg_ptr_to_alloca_too_many_bytes(
; CHECK-NEXT:    [[ALLOCA:%.*]] = alloca [32 x i8], align 4, addrspace(5)
; CHECK-NEXT:    [[ALLOCA_CAST:%.*]] = getelementptr inbounds [32 x i8], [32 x i8] addrspace(5)* [[ALLOCA]], i32 0, i32 0
; CHECK-NEXT:    [[ARG_CAST:%.*]] = getelementptr inbounds [31 x i8], [31 x i8] addrspace(4)* [[ARG:%.*]], i64 0, i64 0
; CHECK-NEXT:    call void @llvm.memcpy.p5i8.p4i8.i64(i8 addrspace(5)* noundef align 4 dereferenceable(31) [[ALLOCA_CAST]], i8 addrspace(4)* noundef align 4 dereferenceable(31) [[ARG_CAST]], i64 31, i1 false)
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr inbounds [32 x i8], [32 x i8] addrspace(5)* [[ALLOCA]], i32 0, i32 [[IDX:%.*]]
; CHECK-NEXT:    [[LOAD:%.*]] = load i8, i8 addrspace(5)* [[GEP]], align 1
; CHECK-NEXT:    store i8 [[LOAD]], i8 addrspace(1)* [[OUT:%.*]], align 1
; CHECK-NEXT:    ret void
;
  %alloca = alloca [32 x i8], align 4, addrspace(5)
  %alloca.cast = bitcast [32 x i8] addrspace(5)* %alloca to i8 addrspace(5)*
  %arg.cast = bitcast [31 x i8] addrspace(4)* %arg to i8 addrspace(4)*
  call void @llvm.memcpy.p5i8.p4i8.i64(i8 addrspace(5)* %alloca.cast, i8 addrspace(4)* %arg.cast, i64 31, i1 false)
  %gep = getelementptr inbounds [32 x i8], [32 x i8] addrspace(5)* %alloca, i32 0, i32 %idx
  %load = load i8, i8 addrspace(5)* %gep
  store i8 %load, i8 addrspace(1)* %out
  ret void
}

; Simple memcpy to alloca from constant address space intrinsic call
define amdgpu_kernel void @memcpy_constant_intrinsic_ptr_to_alloca(i8 addrspace(1)* %out, i32 %idx) {
; CHECK-LABEL: @memcpy_constant_intrinsic_ptr_to_alloca(
; CHECK-NEXT:    [[ALLOCA:%.*]] = alloca [32 x i8], align 4, addrspace(5)
; CHECK-NEXT:    [[ALLOCA_CAST:%.*]] = getelementptr inbounds [32 x i8], [32 x i8] addrspace(5)* [[ALLOCA]], i32 0, i32 0
; CHECK-NEXT:    [[KERNARG_SEGMENT_PTR:%.*]] = call align 16 dereferenceable(32) i8 addrspace(4)* @llvm.amdgcn.kernarg.segment.ptr()
; CHECK-NEXT:    call void @llvm.memcpy.p5i8.p4i8.i64(i8 addrspace(5)* noundef align 4 dereferenceable(32) [[ALLOCA_CAST]], i8 addrspace(4)* noundef align 16 dereferenceable(32) [[KERNARG_SEGMENT_PTR]], i64 32, i1 false)
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr inbounds [32 x i8], [32 x i8] addrspace(5)* [[ALLOCA]], i32 0, i32 [[IDX:%.*]]
; CHECK-NEXT:    [[LOAD:%.*]] = load i8, i8 addrspace(5)* [[GEP]], align 1
; CHECK-NEXT:    store i8 [[LOAD]], i8 addrspace(1)* [[OUT:%.*]], align 1
; CHECK-NEXT:    ret void
;
  %alloca = alloca [32 x i8], align 4, addrspace(5)
  %alloca.cast = bitcast [32 x i8] addrspace(5)* %alloca to i8 addrspace(5)*
  %kernarg.segment.ptr = call dereferenceable(32) align 16 i8 addrspace(4)* @llvm.amdgcn.kernarg.segment.ptr()
  call void @llvm.memcpy.p5i8.p4i8.i64(i8 addrspace(5)* %alloca.cast, i8 addrspace(4)* %kernarg.segment.ptr, i64 32, i1 false)
  %gep = getelementptr inbounds [32 x i8], [32 x i8] addrspace(5)* %alloca, i32 0, i32 %idx
  %load = load i8, i8 addrspace(5)* %gep
  store i8 %load, i8 addrspace(1)* %out
  ret void
}

; Alloca is written through a flat pointer
define i8 @memcpy_constant_arg_ptr_to_alloca_addrspacecast_to_flat([31 x i8] addrspace(4)* noalias readonly align 4 dereferenceable(32) %arg, i32 %idx) {
; CHECK-LABEL: @memcpy_constant_arg_ptr_to_alloca_addrspacecast_to_flat(
; CHECK-NEXT:    [[ALLOCA:%.*]] = alloca [32 x i8], align 4, addrspace(5)
; CHECK-NEXT:    [[ALLOCA_CAST:%.*]] = getelementptr inbounds [32 x i8], [32 x i8] addrspace(5)* [[ALLOCA]], i32 0, i32 0
; CHECK-NEXT:    [[ALLOCA_CAST_ASC:%.*]] = addrspacecast i8 addrspace(5)* [[ALLOCA_CAST]] to i8*
; CHECK-NEXT:    [[ARG_CAST:%.*]] = getelementptr inbounds [31 x i8], [31 x i8] addrspace(4)* [[ARG:%.*]], i64 0, i64 0
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p4i8.i64(i8* noundef nonnull align 1 dereferenceable(31) [[ALLOCA_CAST_ASC]], i8 addrspace(4)* noundef align 4 dereferenceable(31) [[ARG_CAST]], i64 31, i1 false)
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr inbounds [32 x i8], [32 x i8] addrspace(5)* [[ALLOCA]], i32 0, i32 [[IDX:%.*]]
; CHECK-NEXT:    [[LOAD:%.*]] = load i8, i8 addrspace(5)* [[GEP]], align 1
; CHECK-NEXT:    ret i8 [[LOAD]]
;
  %alloca = alloca [32 x i8], align 4, addrspace(5)
  %alloca.cast = bitcast [32 x i8] addrspace(5)* %alloca to i8 addrspace(5)*
  %alloca.cast.asc = addrspacecast i8 addrspace(5)* %alloca.cast to i8*
  %arg.cast = bitcast [31 x i8] addrspace(4)* %arg to i8 addrspace(4)*
  call void @llvm.memcpy.p0i8.p4i8.i64(i8* %alloca.cast.asc, i8 addrspace(4)* %arg.cast, i64 31, i1 false)
  %gep = getelementptr inbounds [32 x i8], [32 x i8] addrspace(5)* %alloca, i32 0, i32 %idx
  %load = load i8, i8 addrspace(5)* %gep
  ret i8 %load
}

; Alloca is only addressed through flat pointer.
define i8 @memcpy_constant_arg_ptr_to_alloca_addrspacecast_to_flat2([32 x i8] addrspace(4)* noalias readonly align 4 dereferenceable(32) %arg, i32 %idx) {
; CHECK-LABEL: @memcpy_constant_arg_ptr_to_alloca_addrspacecast_to_flat2(
; CHECK-NEXT:    [[ALLOCA:%.*]] = alloca [32 x i8], align 4, addrspace(5)
; CHECK-NEXT:    [[ALLOCA_CAST1:%.*]] = getelementptr inbounds [32 x i8], [32 x i8] addrspace(5)* [[ALLOCA]], i32 0, i32 0
; CHECK-NEXT:    [[ALLOCA_CAST:%.*]] = addrspacecast i8 addrspace(5)* [[ALLOCA_CAST1]] to i8*
; CHECK-NEXT:    [[ARG_CAST:%.*]] = getelementptr inbounds [32 x i8], [32 x i8] addrspace(4)* [[ARG:%.*]], i64 0, i64 0
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p4i8.i64(i8* noundef nonnull align 1 dereferenceable(32) [[ALLOCA_CAST]], i8 addrspace(4)* noundef align 4 dereferenceable(32) [[ARG_CAST]], i64 32, i1 false)
; CHECK-NEXT:    [[GEP2:%.*]] = getelementptr inbounds [32 x i8], [32 x i8] addrspace(5)* [[ALLOCA]], i32 0, i32 [[IDX:%.*]]
; CHECK-NEXT:    [[GEP:%.*]] = addrspacecast i8 addrspace(5)* [[GEP2]] to i8*
; CHECK-NEXT:    [[LOAD:%.*]] = load i8, i8* [[GEP]], align 1
; CHECK-NEXT:    ret i8 [[LOAD]]
;
  %alloca = alloca [32 x i8], align 4, addrspace(5)
  %alloca.cast.asc = addrspacecast [32 x i8] addrspace(5)* %alloca to [32 x i8]*
  %alloca.cast = bitcast [32 x i8]* %alloca.cast.asc to i8*
  %arg.cast = bitcast [32 x i8] addrspace(4)* %arg to i8 addrspace(4)*
  call void @llvm.memcpy.p0i8.p4i8.i64(i8* %alloca.cast, i8 addrspace(4)* %arg.cast, i64 32, i1 false)
  %gep = getelementptr inbounds [32 x i8], [32 x i8]* %alloca.cast.asc, i32 0, i32 %idx
  %load = load i8, i8* %gep
  ret i8 %load
}

%struct.ty = type { [4 x i32] }

define amdgpu_kernel void @byref_infloop(i8* %scratch, %struct.ty addrspace(4)* byref(%struct.ty) align 4 %arg) local_unnamed_addr #1 {
; CHECK-LABEL: @byref_infloop(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    [[CAST_ALLOCA:%.*]] = bitcast [[STRUCT_TY:%.*]] addrspace(4)* [[ARG:%.*]] to i8 addrspace(4)*
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p4i8.i32(i8* noundef nonnull align 4 dereferenceable(16) [[SCRATCH:%.*]], i8 addrspace(4)* noundef align 4 dereferenceable(16) [[CAST_ALLOCA]], i32 16, i1 false)
; CHECK-NEXT:    ret void
;
bb:
  %alloca = alloca [4 x i32], align 4, addrspace(5)
  %cast.arg = bitcast %struct.ty addrspace(4)* %arg to i8 addrspace(4)*
  %cast.alloca = bitcast [4 x i32] addrspace(5)* %alloca to i8 addrspace(5)*
  call void @llvm.memcpy.p5i8.p4i8.i32(i8 addrspace(5)* align 4 %cast.alloca, i8 addrspace(4)* align 4 %cast.arg, i32 16, i1 false)
  call void @llvm.memcpy.p0i8.p5i8.i32(i8* align 4 %scratch, i8 addrspace(5)* align 4 %cast.alloca, i32 16, i1 false)
  ret void
}

define amdgpu_kernel void @byref_infloop_metadata(i8* %scratch, %struct.ty addrspace(4)* byref(%struct.ty) align 4 %arg) local_unnamed_addr #1 {
; CHECK-LABEL: @byref_infloop_metadata(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    [[CAST_ALLOCA:%.*]] = bitcast [[STRUCT_TY:%.*]] addrspace(4)* [[ARG:%.*]] to i8 addrspace(4)*
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p4i8.i32(i8* noundef nonnull align 4 dereferenceable(16) [[SCRATCH:%.*]], i8 addrspace(4)* noundef align 4 dereferenceable(16) [[CAST_ALLOCA]], i32 16, i1 false), !noalias !1
; CHECK-NEXT:    ret void
;
bb:
  %alloca = alloca [4 x i32], align 4, addrspace(5)
  %cast.arg = bitcast %struct.ty addrspace(4)* %arg to i8 addrspace(4)*
  %cast.alloca = bitcast [4 x i32] addrspace(5)* %alloca to i8 addrspace(5)*
  call void @llvm.memcpy.p5i8.p4i8.i32(i8 addrspace(5)* align 4 %cast.alloca, i8 addrspace(4)* align 4 %cast.arg, i32 16, i1 false), !noalias !0
  call void @llvm.memcpy.p0i8.p5i8.i32(i8* align 4 %scratch, i8 addrspace(5)* align 4 %cast.alloca, i32 16, i1 false), !noalias !1
  ret void
}

define amdgpu_kernel void @byref_infloop_addrspacecast(i8* %scratch, %struct.ty addrspace(4)* byref(%struct.ty) align 4 %arg) local_unnamed_addr #1 {
; CHECK-LABEL: @byref_infloop_addrspacecast(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    [[ALLOCA:%.*]] = alloca [4 x i32], align 4, addrspace(5)
; CHECK-NEXT:    [[CAST_ARG:%.*]] = bitcast [[STRUCT_TY:%.*]] addrspace(4)* [[ARG:%.*]] to i8 addrspace(4)*
; CHECK-NEXT:    [[CAST_ALLOCA:%.*]] = bitcast [4 x i32] addrspace(5)* [[ALLOCA]] to i8 addrspace(5)*
; CHECK-NEXT:    [[ADDRSPACECAST_ALLOCA:%.*]] = addrspacecast i8 addrspace(5)* [[CAST_ALLOCA]] to i8*
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p4i8.i64(i8* noundef nonnull align 4 dereferenceable(16) [[ADDRSPACECAST_ALLOCA]], i8 addrspace(4)* noundef align 4 dereferenceable(16) [[CAST_ARG]], i64 16, i1 false)
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 4 dereferenceable(16) [[SCRATCH:%.*]], i8* noundef nonnull align 4 dereferenceable(16) [[ADDRSPACECAST_ALLOCA]], i64 16, i1 false)
; CHECK-NEXT:    ret void
;
bb:
  %alloca = alloca [4 x i32], align 4, addrspace(5)
  %cast.arg = bitcast %struct.ty addrspace(4)* %arg to i8 addrspace(4)*
  %cast.alloca = bitcast [4 x i32] addrspace(5)* %alloca to i8 addrspace(5)*
  %addrspacecast.alloca = addrspacecast i8 addrspace(5)* %cast.alloca to i8*
  call void @llvm.memcpy.p0i8.p4i8.i64(i8* nonnull align 4 dereferenceable(16) %addrspacecast.alloca, i8 addrspace(4)* align 4 dereferenceable(16) %cast.arg, i64 16, i1 false)
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 4 dereferenceable(16) %scratch, i8* nonnull align 4 dereferenceable(16) %addrspacecast.alloca, i64 16, i1 false)
  ret void
}

define amdgpu_kernel void @byref_infloop_memmove(i8* %scratch, %struct.ty addrspace(4)* byref(%struct.ty) align 4 %arg) local_unnamed_addr #1 {
; CHECK-LABEL: @byref_infloop_memmove(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    [[CAST_ALLOCA:%.*]] = bitcast [[STRUCT_TY:%.*]] addrspace(4)* [[ARG:%.*]] to i8 addrspace(4)*
; CHECK-NEXT:    call void @llvm.memmove.p0i8.p4i8.i32(i8* noundef nonnull align 4 dereferenceable(16) [[SCRATCH:%.*]], i8 addrspace(4)* noundef align 4 dereferenceable(16) [[CAST_ALLOCA]], i32 16, i1 false)
; CHECK-NEXT:    ret void
;
bb:
  %alloca = alloca [4 x i32], align 4, addrspace(5)
  %cast.arg = bitcast %struct.ty addrspace(4)* %arg to i8 addrspace(4)*
  %cast.alloca = bitcast [4 x i32] addrspace(5)* %alloca to i8 addrspace(5)*
  call void @llvm.memmove.p5i8.p4i8.i32(i8 addrspace(5)* align 4 %cast.alloca, i8 addrspace(4)* align 4 %cast.arg, i32 16, i1 false)
  call void @llvm.memmove.p0i8.p5i8.i32(i8* align 4 %scratch, i8 addrspace(5)* align 4 %cast.alloca, i32 16, i1 false)
  ret void
}

declare void @llvm.memcpy.p0i8.p5i8.i32(i8* noalias nocapture writeonly, i8 addrspace(5)* noalias nocapture readonly, i32, i1 immarg) #0
declare void @llvm.memcpy.p5i8.p4i8.i32(i8 addrspace(5)* nocapture, i8 addrspace(4)* nocapture, i32, i1) #0
declare void @llvm.memcpy.p0i8.p4i8.i64(i8* nocapture, i8 addrspace(4)* nocapture, i64, i1) #0
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #0
declare void @llvm.memcpy.p5i8.p4i8.i64(i8 addrspace(5)* nocapture, i8 addrspace(4)* nocapture, i64, i1) #0
declare void @llvm.memmove.p5i8.p4i8.i32(i8 addrspace(5)* nocapture, i8 addrspace(4)* nocapture, i32, i1) #0
declare void @llvm.memmove.p0i8.p5i8.i32(i8* nocapture, i8 addrspace(5)* nocapture, i32, i1) #0
declare i8 addrspace(4)* @llvm.amdgcn.kernarg.segment.ptr() #1

attributes #0 = { argmemonly nounwind willreturn }
attributes #1 = { nounwind readnone speculatable }

!0 = !{!0}
!1 = !{!1}
