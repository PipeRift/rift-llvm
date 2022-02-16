; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes=rewrite-statepoints-for-gc -S < %s | FileCheck %s

declare i8 addrspace(1)* @llvm.experimental.gc.get.pointer.base.p1i8.p1i8(i8 addrspace(1)* readnone nocapture) nounwind readnone willreturn
declare void @foo()

define i8 addrspace(1)* @test_duplicate_base_generation(i8 addrspace(1)* %obj1, i8 addrspace(1)* %obj2, i1 %c) gc "statepoint-example" {
; CHECK-LABEL: @test_duplicate_base_generation(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[OBJ1_12:%.*]] = getelementptr inbounds i8, i8 addrspace(1)* [[OBJ1:%.*]], i64 12
; CHECK-NEXT:    [[OBJ2_16:%.*]] = getelementptr inbounds i8, i8 addrspace(1)* [[OBJ2:%.*]], i64 16
; CHECK-NEXT:    [[SELECTED_BASE:%.*]] = select i1 [[C:%.*]], i8 addrspace(1)* [[OBJ2]], i8 addrspace(1)* [[OBJ1]], !is_base_value !0
; CHECK-NEXT:    [[SELECTED:%.*]] = select i1 [[C]], i8 addrspace(1)* [[OBJ2_16]], i8 addrspace(1)* [[OBJ1_12]]
; CHECK-NEXT:    [[STATEPOINT_TOKEN:%.*]] = call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 2882400000, i32 0, void ()* @foo, i32 0, i32 0, i32 0, i32 0) [ "gc-live"(i8 addrspace(1)* [[SELECTED]], i8 addrspace(1)* [[SELECTED_BASE]]) ]
; CHECK-NEXT:    [[SELECTED_RELOCATED:%.*]] = call coldcc i8 addrspace(1)* @llvm.experimental.gc.relocate.p1i8(token [[STATEPOINT_TOKEN]], i32 1, i32 0)
; CHECK-NEXT:    [[SELECTED_BASE_RELOCATED:%.*]] = call coldcc i8 addrspace(1)* @llvm.experimental.gc.relocate.p1i8(token [[STATEPOINT_TOKEN]], i32 1, i32 1)
; CHECK-NEXT:    ret i8 addrspace(1)* [[SELECTED_RELOCATED]]
;
entry:
  %obj1.12 = getelementptr inbounds i8, i8 addrspace(1)* %obj1, i64 12
  %obj2.16 = getelementptr inbounds i8, i8 addrspace(1)* %obj2, i64 16
  %selected = select i1 %c, i8 addrspace(1)* %obj2.16, i8 addrspace(1)* %obj1.12
  %base = call i8 addrspace(1)* @llvm.experimental.gc.get.pointer.base.p1i8.p1i8(i8 addrspace(1)* %selected)
  call void @foo()
  ret i8 addrspace(1)* %selected
}
