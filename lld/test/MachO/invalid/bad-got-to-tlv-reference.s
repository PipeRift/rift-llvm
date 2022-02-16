# REQUIRES: x86
# RUN: llvm-mc -filetype=obj -triple=x86_64-apple-darwin %s -o %t.o
# RUN: not %lld -o /dev/null %t.o 2>&1 | FileCheck %s -DFILE=%t.o

# CHECK: error: GOT_LOAD relocation requires that variable not be thread-local for `_foo' in [[FILE]]:(__text)

.text
.globl _main
_main:
  movq _foo@GOTPCREL(%rip), %rax
  ret

.section __DATA,__thread_vars,thread_local_variables
_foo:
