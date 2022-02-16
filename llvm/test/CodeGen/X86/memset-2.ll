; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=i386-apple-darwin9 -mcpu=yonah < %s | FileCheck %s

define fastcc void @t1() nounwind {
; CHECK-LABEL: t1:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    subl $16, %esp
; CHECK-NEXT:    pushl $188
; CHECK-NEXT:    pushl $0
; CHECK-NEXT:    pushl $0
; CHECK-NEXT:    calll _memset
; CHECK-NEXT:    addl $16, %esp
; CHECK-NEXT:    ud2
entry:
  call void @llvm.memset.p0i8.i32(i8* null, i8 0, i32 188, i1 false)
  unreachable
}

define fastcc void @t2(i8 signext %c) nounwind {
; CHECK-LABEL: t2:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    subl $12, %esp
; CHECK-NEXT:    movl %ecx, {{[0-9]+}}(%esp)
; CHECK-NEXT:    movl $76, {{[0-9]+}}(%esp)
; CHECK-NEXT:    calll _memset
; CHECK-NEXT:    ud2
entry:
  call void @llvm.memset.p0i8.i32(i8* undef, i8 %c, i32 76, i1 false)
  unreachable
}

declare void @llvm.memset.p0i8.i32(i8* nocapture, i8, i32, i1) nounwind

define void @t3(i8* nocapture %s, i8 %a) nounwind {
; CHECK-LABEL: t3:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    movzbl {{[0-9]+}}(%esp), %ecx
; CHECK-NEXT:    imull $16843009, %ecx, %ecx ## imm = 0x1010101
; CHECK-NEXT:    movl %ecx, 4(%eax)
; CHECK-NEXT:    movl %ecx, (%eax)
; CHECK-NEXT:    retl
entry:
  tail call void @llvm.memset.p0i8.i32(i8* %s, i8 %a, i32 8, i1 false)
  ret void
}

define void @t4(i8* nocapture %s, i8 %a) nounwind {
; CHECK-LABEL: t4:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    movzbl {{[0-9]+}}(%esp), %ecx
; CHECK-NEXT:    imull $16843009, %ecx, %ecx ## imm = 0x1010101
; CHECK-NEXT:    movl %ecx, 11(%eax)
; CHECK-NEXT:    movl %ecx, 8(%eax)
; CHECK-NEXT:    movl %ecx, 4(%eax)
; CHECK-NEXT:    movl %ecx, (%eax)
; CHECK-NEXT:    retl
entry:
  tail call void @llvm.memset.p0i8.i32(i8* %s, i8 %a, i32 15, i1 false)
  ret void
}
