// RUN: llvm-mc -arch=amdgcn -mcpu=bonaire -show-encoding %s | FileCheck %s

s_nop 0x3141
// CHECK: [0x41,0x31,0x80,0xbf]

s_nop 0xc1d1
// CHECK: [0xd1,0xc1,0x80,0xbf]

s_endpgm
// CHECK: [0x00,0x00,0x81,0xbf]

s_branch 12609
// CHECK: [0x41,0x31,0x82,0xbf]

s_branch 49617
// CHECK: [0xd1,0xc1,0x82,0xbf]

s_cbranch_scc0 12609
// CHECK: [0x41,0x31,0x84,0xbf]

s_cbranch_scc0 49617
// CHECK: [0xd1,0xc1,0x84,0xbf]

s_cbranch_scc1 12609
// CHECK: [0x41,0x31,0x85,0xbf]

s_cbranch_scc1 49617
// CHECK: [0xd1,0xc1,0x85,0xbf]

s_cbranch_vccz 12609
// CHECK: [0x41,0x31,0x86,0xbf]

s_cbranch_vccz 49617
// CHECK: [0xd1,0xc1,0x86,0xbf]

s_cbranch_vccnz 12609
// CHECK: [0x41,0x31,0x87,0xbf]

s_cbranch_vccnz 49617
// CHECK: [0xd1,0xc1,0x87,0xbf]

s_cbranch_execz 12609
// CHECK: [0x41,0x31,0x88,0xbf]

s_cbranch_execz 49617
// CHECK: [0xd1,0xc1,0x88,0xbf]

s_cbranch_execnz 12609
// CHECK: [0x41,0x31,0x89,0xbf]

s_cbranch_execnz 49617
// CHECK: [0xd1,0xc1,0x89,0xbf]

s_barrier
// CHECK: [0x00,0x00,0x8a,0xbf]

s_setkill 0x3141
// CHECK: [0x41,0x31,0x8b,0xbf]

s_setkill 0xc1d1
// CHECK: [0xd1,0xc1,0x8b,0xbf]

s_waitcnt 0x3141
// CHECK: [0x41,0x31,0x8c,0xbf]

s_waitcnt 0xc1d1
// CHECK: [0xd1,0xc1,0x8c,0xbf]

s_sethalt 0x3141
// CHECK: [0x41,0x31,0x8d,0xbf]

s_sethalt 0xc1d1
// CHECK: [0xd1,0xc1,0x8d,0xbf]

s_sleep 0x3141
// CHECK: [0x41,0x31,0x8e,0xbf]

s_sleep 0xc1d1
// CHECK: [0xd1,0xc1,0x8e,0xbf]

s_setprio 0x3141
// CHECK: [0x41,0x31,0x8f,0xbf]

s_setprio 0xc1d1
// CHECK: [0xd1,0xc1,0x8f,0xbf]

s_sendmsg 0x3141
// CHECK: [0x41,0x31,0x90,0xbf]

s_sendmsg 0xc1d1
// CHECK: [0xd1,0xc1,0x90,0xbf]

s_sendmsghalt 0x3141
// CHECK: [0x41,0x31,0x91,0xbf]

s_sendmsghalt 0xc1d1
// CHECK: [0xd1,0xc1,0x91,0xbf]

s_trap 0x3141
// CHECK: [0x41,0x31,0x92,0xbf]

s_trap 0xc1d1
// CHECK: [0xd1,0xc1,0x92,0xbf]

s_icache_inv
// CHECK: [0x00,0x00,0x93,0xbf]

s_incperflevel 0x3141
// CHECK: [0x41,0x31,0x94,0xbf]

s_incperflevel 0xc1d1
// CHECK: [0xd1,0xc1,0x94,0xbf]

s_decperflevel 0x3141
// CHECK: [0x41,0x31,0x95,0xbf]

s_decperflevel 0xc1d1
// CHECK: [0xd1,0xc1,0x95,0xbf]

s_ttracedata
// CHECK: [0x00,0x00,0x96,0xbf]

s_cbranch_cdbgsys 12609
// CHECK: [0x41,0x31,0x97,0xbf]

s_cbranch_cdbgsys 49617
// CHECK: [0xd1,0xc1,0x97,0xbf]

s_cbranch_cdbguser 12609
// CHECK: [0x41,0x31,0x98,0xbf]

s_cbranch_cdbguser 49617
// CHECK: [0xd1,0xc1,0x98,0xbf]

s_cbranch_cdbgsys_or_user 12609
// CHECK: [0x41,0x31,0x99,0xbf]

s_cbranch_cdbgsys_or_user 49617
// CHECK: [0xd1,0xc1,0x99,0xbf]

s_cbranch_cdbgsys_and_user 12609
// CHECK: [0x41,0x31,0x9a,0xbf]

s_cbranch_cdbgsys_and_user 49617
// CHECK: [0xd1,0xc1,0x9a,0xbf]
