; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx  | FileCheck %s --check-prefix=ALL --check-prefix=AVX
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx2 | FileCheck %s --check-prefix=ALL --check-prefix=AVX2

; 0'th element insertion into an AVX register.

define <8 x float> @insert_f32_firstelt_of_low_subvector(<8 x float> %x, float %s) {
; ALL-LABEL: insert_f32_firstelt_of_low_subvector:
; ALL:       # %bb.0:
; ALL-NEXT:    # kill: def $xmm1 killed $xmm1 def $ymm1
; ALL-NEXT:    vblendps {{.*#+}} ymm0 = ymm1[0],ymm0[1,2,3,4,5,6,7]
; ALL-NEXT:    retq
  %i0 = insertelement <8 x float> %x, float %s, i32 0
  ret <8 x float> %i0
}

define <4 x double> @insert_f64_firstelt_of_low_subvector(<4 x double> %x, double %s) {
; ALL-LABEL: insert_f64_firstelt_of_low_subvector:
; ALL:       # %bb.0:
; ALL-NEXT:    # kill: def $xmm1 killed $xmm1 def $ymm1
; ALL-NEXT:    vblendps {{.*#+}} ymm0 = ymm1[0,1],ymm0[2,3,4,5,6,7]
; ALL-NEXT:    retq
  %i0 = insertelement <4 x double> %x, double %s, i32 0
  ret <4 x double> %i0
}

define <32 x i8> @insert_i8_firstelt_of_low_subvector(<32 x i8> %x, i8 %s) {
; AVX-LABEL: insert_i8_firstelt_of_low_subvector:
; AVX:       # %bb.0:
; AVX-NEXT:    vpinsrb $0, %edi, %xmm0, %xmm1
; AVX-NEXT:    vblendps {{.*#+}} ymm0 = ymm1[0,1,2,3],ymm0[4,5,6,7]
; AVX-NEXT:    retq
;
; AVX2-LABEL: insert_i8_firstelt_of_low_subvector:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpinsrb $0, %edi, %xmm0, %xmm1
; AVX2-NEXT:    vpblendd {{.*#+}} ymm0 = ymm1[0,1,2,3],ymm0[4,5,6,7]
; AVX2-NEXT:    retq
  %i0 = insertelement <32 x i8> %x, i8 %s, i32 0
  ret <32 x i8> %i0
}

define <16 x i16> @insert_i16_firstelt_of_low_subvector(<16 x i16> %x, i16 %s) {
; AVX-LABEL: insert_i16_firstelt_of_low_subvector:
; AVX:       # %bb.0:
; AVX-NEXT:    vpinsrw $0, %edi, %xmm0, %xmm1
; AVX-NEXT:    vblendps {{.*#+}} ymm0 = ymm1[0,1,2,3],ymm0[4,5,6,7]
; AVX-NEXT:    retq
;
; AVX2-LABEL: insert_i16_firstelt_of_low_subvector:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpinsrw $0, %edi, %xmm0, %xmm1
; AVX2-NEXT:    vpblendd {{.*#+}} ymm0 = ymm1[0,1,2,3],ymm0[4,5,6,7]
; AVX2-NEXT:    retq
  %i0 = insertelement <16 x i16> %x, i16 %s, i32 0
  ret <16 x i16> %i0
}

define <8 x i32> @insert_i32_firstelt_of_low_subvector(<8 x i32> %x, i32 %s) {
; AVX-LABEL: insert_i32_firstelt_of_low_subvector:
; AVX:       # %bb.0:
; AVX-NEXT:    vpinsrd $0, %edi, %xmm0, %xmm1
; AVX-NEXT:    vblendps {{.*#+}} ymm0 = ymm1[0,1,2,3],ymm0[4,5,6,7]
; AVX-NEXT:    retq
;
; AVX2-LABEL: insert_i32_firstelt_of_low_subvector:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vmovd %edi, %xmm1
; AVX2-NEXT:    vpblendd {{.*#+}} ymm0 = ymm1[0],ymm0[1,2,3,4,5,6,7]
; AVX2-NEXT:    retq
  %i0 = insertelement <8 x i32> %x, i32 %s, i32 0
  ret <8 x i32> %i0
}

define <4 x i64> @insert_i64_firstelt_of_low_subvector(<4 x i64> %x, i64 %s) {
; AVX-LABEL: insert_i64_firstelt_of_low_subvector:
; AVX:       # %bb.0:
; AVX-NEXT:    vpinsrq $0, %rdi, %xmm0, %xmm1
; AVX-NEXT:    vblendps {{.*#+}} ymm0 = ymm1[0,1,2,3],ymm0[4,5,6,7]
; AVX-NEXT:    retq
;
; AVX2-LABEL: insert_i64_firstelt_of_low_subvector:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpinsrq $0, %rdi, %xmm0, %xmm1
; AVX2-NEXT:    vpblendd {{.*#+}} ymm0 = ymm1[0,1,2,3],ymm0[4,5,6,7]
; AVX2-NEXT:    retq
  %i0 = insertelement <4 x i64> %x, i64 %s, i32 0
  ret <4 x i64> %i0
}

; 0'th element of high subvector insertion into an AVX register.

define <8 x float> @insert_f32_firstelt_of_high_subvector(<8 x float> %x, float %s) {
; ALL-LABEL: insert_f32_firstelt_of_high_subvector:
; ALL:       # %bb.0:
; ALL-NEXT:    vextractf128 $1, %ymm0, %xmm2
; ALL-NEXT:    vblendps {{.*#+}} xmm1 = xmm1[0],xmm2[1,2,3]
; ALL-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; ALL-NEXT:    retq
  %i0 = insertelement <8 x float> %x, float %s, i32 4
  ret <8 x float> %i0
}

define <4 x double> @insert_f64_firstelt_of_high_subvector(<4 x double> %x, double %s) {
; ALL-LABEL: insert_f64_firstelt_of_high_subvector:
; ALL:       # %bb.0:
; ALL-NEXT:    vextractf128 $1, %ymm0, %xmm2
; ALL-NEXT:    vblendps {{.*#+}} xmm1 = xmm1[0,1],xmm2[2,3]
; ALL-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; ALL-NEXT:    retq
  %i0 = insertelement <4 x double> %x, double %s, i32 2
  ret <4 x double> %i0
}

define <32 x i8> @insert_i8_firstelt_of_high_subvector(<32 x i8> %x, i8 %s) {
; AVX-LABEL: insert_i8_firstelt_of_high_subvector:
; AVX:       # %bb.0:
; AVX-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX-NEXT:    vpinsrb $0, %edi, %xmm1, %xmm1
; AVX-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; AVX-NEXT:    retq
;
; AVX2-LABEL: insert_i8_firstelt_of_high_subvector:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vextracti128 $1, %ymm0, %xmm1
; AVX2-NEXT:    vpinsrb $0, %edi, %xmm1, %xmm1
; AVX2-NEXT:    vinserti128 $1, %xmm1, %ymm0, %ymm0
; AVX2-NEXT:    retq
  %i0 = insertelement <32 x i8> %x, i8 %s, i32 16
  ret <32 x i8> %i0
}

define <16 x i16> @insert_i16_firstelt_of_high_subvector(<16 x i16> %x, i16 %s) {
; AVX-LABEL: insert_i16_firstelt_of_high_subvector:
; AVX:       # %bb.0:
; AVX-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX-NEXT:    vpinsrw $0, %edi, %xmm1, %xmm1
; AVX-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; AVX-NEXT:    retq
;
; AVX2-LABEL: insert_i16_firstelt_of_high_subvector:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vextracti128 $1, %ymm0, %xmm1
; AVX2-NEXT:    vpinsrw $0, %edi, %xmm1, %xmm1
; AVX2-NEXT:    vinserti128 $1, %xmm1, %ymm0, %ymm0
; AVX2-NEXT:    retq
  %i0 = insertelement <16 x i16> %x, i16 %s, i32 8
  ret <16 x i16> %i0
}

define <8 x i32> @insert_i32_firstelt_of_high_subvector(<8 x i32> %x, i32 %s) {
; AVX-LABEL: insert_i32_firstelt_of_high_subvector:
; AVX:       # %bb.0:
; AVX-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX-NEXT:    vpinsrd $0, %edi, %xmm1, %xmm1
; AVX-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; AVX-NEXT:    retq
;
; AVX2-LABEL: insert_i32_firstelt_of_high_subvector:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vextracti128 $1, %ymm0, %xmm1
; AVX2-NEXT:    vpinsrd $0, %edi, %xmm1, %xmm1
; AVX2-NEXT:    vinserti128 $1, %xmm1, %ymm0, %ymm0
; AVX2-NEXT:    retq
  %i0 = insertelement <8 x i32> %x, i32 %s, i32 4
  ret <8 x i32> %i0
}

define <4 x i64> @insert_i64_firstelt_of_high_subvector(<4 x i64> %x, i64 %s) {
; AVX-LABEL: insert_i64_firstelt_of_high_subvector:
; AVX:       # %bb.0:
; AVX-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX-NEXT:    vpinsrq $0, %rdi, %xmm1, %xmm1
; AVX-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; AVX-NEXT:    retq
;
; AVX2-LABEL: insert_i64_firstelt_of_high_subvector:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vextracti128 $1, %ymm0, %xmm1
; AVX2-NEXT:    vpinsrq $0, %rdi, %xmm1, %xmm1
; AVX2-NEXT:    vinserti128 $1, %xmm1, %ymm0, %ymm0
; AVX2-NEXT:    retq
  %i0 = insertelement <4 x i64> %x, i64 %s, i32 2
  ret <4 x i64> %i0
}

; element insertion into 0'th element of both subvectors

define <8 x float> @insert_f32_firstelts(<8 x float> %x, float %s) {
; ALL-LABEL: insert_f32_firstelts:
; ALL:       # %bb.0:
; ALL-NEXT:    vblendps {{.*#+}} xmm2 = xmm1[0],xmm0[1,2,3]
; ALL-NEXT:    vextractf128 $1, %ymm0, %xmm0
; ALL-NEXT:    vblendps {{.*#+}} xmm0 = xmm1[0],xmm0[1,2,3]
; ALL-NEXT:    vinsertf128 $1, %xmm0, %ymm2, %ymm0
; ALL-NEXT:    retq
  %i0 = insertelement <8 x float> %x, float %s, i32 0
  %i1 = insertelement <8 x float> %i0, float %s, i32 4
  ret <8 x float> %i1
}

define <4 x double> @insert_f64_firstelts(<4 x double> %x, double %s) {
; ALL-LABEL: insert_f64_firstelts:
; ALL:       # %bb.0:
; ALL-NEXT:    vblendps {{.*#+}} xmm2 = xmm1[0,1],xmm0[2,3]
; ALL-NEXT:    vextractf128 $1, %ymm0, %xmm0
; ALL-NEXT:    vblendps {{.*#+}} xmm0 = xmm1[0,1],xmm0[2,3]
; ALL-NEXT:    vinsertf128 $1, %xmm0, %ymm2, %ymm0
; ALL-NEXT:    retq
  %i0 = insertelement <4 x double> %x, double %s, i32 0
  %i1 = insertelement <4 x double> %i0, double %s, i32 2
  ret <4 x double> %i1
}

define <32 x i8> @insert_i8_firstelts(<32 x i8> %x, i8 %s) {
; AVX-LABEL: insert_i8_firstelts:
; AVX:       # %bb.0:
; AVX-NEXT:    vpinsrb $0, %edi, %xmm0, %xmm1
; AVX-NEXT:    vextractf128 $1, %ymm0, %xmm0
; AVX-NEXT:    vpinsrb $0, %edi, %xmm0, %xmm0
; AVX-NEXT:    vinsertf128 $1, %xmm0, %ymm1, %ymm0
; AVX-NEXT:    retq
;
; AVX2-LABEL: insert_i8_firstelts:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpinsrb $0, %edi, %xmm0, %xmm1
; AVX2-NEXT:    vextracti128 $1, %ymm0, %xmm0
; AVX2-NEXT:    vpinsrb $0, %edi, %xmm0, %xmm0
; AVX2-NEXT:    vinserti128 $1, %xmm0, %ymm1, %ymm0
; AVX2-NEXT:    retq
  %i0 = insertelement <32 x i8> %x, i8 %s, i32 0
  %i1 = insertelement <32 x i8> %i0, i8 %s, i32 16
  ret <32 x i8> %i1
}

define <16 x i16> @insert_i16_firstelts(<16 x i16> %x, i16 %s) {
; AVX-LABEL: insert_i16_firstelts:
; AVX:       # %bb.0:
; AVX-NEXT:    vpinsrw $0, %edi, %xmm0, %xmm1
; AVX-NEXT:    vextractf128 $1, %ymm0, %xmm0
; AVX-NEXT:    vpinsrw $0, %edi, %xmm0, %xmm0
; AVX-NEXT:    vinsertf128 $1, %xmm0, %ymm1, %ymm0
; AVX-NEXT:    retq
;
; AVX2-LABEL: insert_i16_firstelts:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpinsrw $0, %edi, %xmm0, %xmm1
; AVX2-NEXT:    vextracti128 $1, %ymm0, %xmm0
; AVX2-NEXT:    vpinsrw $0, %edi, %xmm0, %xmm0
; AVX2-NEXT:    vinserti128 $1, %xmm0, %ymm1, %ymm0
; AVX2-NEXT:    retq
  %i0 = insertelement <16 x i16> %x, i16 %s, i32 0
  %i1 = insertelement <16 x i16> %i0, i16 %s, i32 8
  ret <16 x i16> %i1
}

define <8 x i32> @insert_i32_firstelts(<8 x i32> %x, i32 %s) {
; AVX-LABEL: insert_i32_firstelts:
; AVX:       # %bb.0:
; AVX-NEXT:    vpinsrd $0, %edi, %xmm0, %xmm1
; AVX-NEXT:    vextractf128 $1, %ymm0, %xmm0
; AVX-NEXT:    vpinsrd $0, %edi, %xmm0, %xmm0
; AVX-NEXT:    vinsertf128 $1, %xmm0, %ymm1, %ymm0
; AVX-NEXT:    retq
;
; AVX2-LABEL: insert_i32_firstelts:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vmovd %edi, %xmm1
; AVX2-NEXT:    vpblendd {{.*#+}} xmm1 = xmm1[0],xmm0[1,2,3]
; AVX2-NEXT:    vextracti128 $1, %ymm0, %xmm0
; AVX2-NEXT:    vpinsrd $0, %edi, %xmm0, %xmm0
; AVX2-NEXT:    vinserti128 $1, %xmm0, %ymm1, %ymm0
; AVX2-NEXT:    retq
  %i0 = insertelement <8 x i32> %x, i32 %s, i32 0
  %i1 = insertelement <8 x i32> %i0, i32 %s, i32 4
  ret <8 x i32> %i1
}

define <4 x i64> @insert_i64_firstelts(<4 x i64> %x, i64 %s) {
; AVX-LABEL: insert_i64_firstelts:
; AVX:       # %bb.0:
; AVX-NEXT:    vpinsrq $0, %rdi, %xmm0, %xmm1
; AVX-NEXT:    vextractf128 $1, %ymm0, %xmm0
; AVX-NEXT:    vpinsrq $0, %rdi, %xmm0, %xmm0
; AVX-NEXT:    vinsertf128 $1, %xmm0, %ymm1, %ymm0
; AVX-NEXT:    retq
;
; AVX2-LABEL: insert_i64_firstelts:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpinsrq $0, %rdi, %xmm0, %xmm1
; AVX2-NEXT:    vextracti128 $1, %ymm0, %xmm0
; AVX2-NEXT:    vpinsrq $0, %rdi, %xmm0, %xmm0
; AVX2-NEXT:    vinserti128 $1, %xmm0, %ymm1, %ymm0
; AVX2-NEXT:    retq
  %i0 = insertelement <4 x i64> %x, i64 %s, i32 0
  %i1 = insertelement <4 x i64> %i0, i64 %s, i32 2
  ret <4 x i64> %i1
}

; element insertion into two elements of high subvector

define <8 x float> @insert_f32_two_elts_of_high_subvector(<8 x float> %x, float %s) {
; ALL-LABEL: insert_f32_two_elts_of_high_subvector:
; ALL:       # %bb.0:
; ALL-NEXT:    vextractf128 $1, %ymm0, %xmm2
; ALL-NEXT:    vshufps {{.*#+}} xmm1 = xmm1[0,0],xmm2[2,3]
; ALL-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; ALL-NEXT:    retq
  %i0 = insertelement <8 x float> %x, float %s, i32 4
  %i1 = insertelement <8 x float> %i0, float %s, i32 5
  ret <8 x float> %i1
}

define <4 x double> @insert_f64_two_elts_of_high_subvector(<4 x double> %x, double %s) {
; ALL-LABEL: insert_f64_two_elts_of_high_subvector:
; ALL:       # %bb.0:
; ALL-NEXT:    vmovddup {{.*#+}} xmm1 = xmm1[0,0]
; ALL-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; ALL-NEXT:    retq
  %i0 = insertelement <4 x double> %x, double %s, i32 2
  %i1 = insertelement <4 x double> %i0, double %s, i32 3
  ret <4 x double> %i1
}

define <32 x i8> @insert_i8_two_elts_of_high_subvector(<32 x i8> %x, i8 %s) {
; AVX-LABEL: insert_i8_two_elts_of_high_subvector:
; AVX:       # %bb.0:
; AVX-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX-NEXT:    vpinsrb $0, %edi, %xmm1, %xmm1
; AVX-NEXT:    vpinsrb $1, %edi, %xmm1, %xmm1
; AVX-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; AVX-NEXT:    retq
;
; AVX2-LABEL: insert_i8_two_elts_of_high_subvector:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vextracti128 $1, %ymm0, %xmm1
; AVX2-NEXT:    vpinsrb $0, %edi, %xmm1, %xmm1
; AVX2-NEXT:    vpinsrb $1, %edi, %xmm1, %xmm1
; AVX2-NEXT:    vinserti128 $1, %xmm1, %ymm0, %ymm0
; AVX2-NEXT:    retq
  %i0 = insertelement <32 x i8> %x, i8 %s, i32 16
  %i1 = insertelement <32 x i8> %i0, i8 %s, i32 17
  ret <32 x i8> %i1
}

define <16 x i16> @insert_i16_two_elts_of_high_subvector(<16 x i16> %x, i16 %s) {
; AVX-LABEL: insert_i16_two_elts_of_high_subvector:
; AVX:       # %bb.0:
; AVX-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX-NEXT:    vpinsrw $0, %edi, %xmm1, %xmm1
; AVX-NEXT:    vpinsrw $1, %edi, %xmm1, %xmm1
; AVX-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; AVX-NEXT:    retq
;
; AVX2-LABEL: insert_i16_two_elts_of_high_subvector:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vextracti128 $1, %ymm0, %xmm1
; AVX2-NEXT:    vpinsrw $0, %edi, %xmm1, %xmm1
; AVX2-NEXT:    vpinsrw $1, %edi, %xmm1, %xmm1
; AVX2-NEXT:    vinserti128 $1, %xmm1, %ymm0, %ymm0
; AVX2-NEXT:    retq
  %i0 = insertelement <16 x i16> %x, i16 %s, i32 8
  %i1 = insertelement <16 x i16> %i0, i16 %s, i32 9
  ret <16 x i16> %i1
}

define <8 x i32> @insert_i32_two_elts_of_high_subvector(<8 x i32> %x, i32 %s) {
; AVX-LABEL: insert_i32_two_elts_of_high_subvector:
; AVX:       # %bb.0:
; AVX-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX-NEXT:    vpinsrd $0, %edi, %xmm1, %xmm1
; AVX-NEXT:    vpinsrd $1, %edi, %xmm1, %xmm1
; AVX-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; AVX-NEXT:    retq
;
; AVX2-LABEL: insert_i32_two_elts_of_high_subvector:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vextracti128 $1, %ymm0, %xmm1
; AVX2-NEXT:    vpinsrd $0, %edi, %xmm1, %xmm1
; AVX2-NEXT:    vpinsrd $1, %edi, %xmm1, %xmm1
; AVX2-NEXT:    vinserti128 $1, %xmm1, %ymm0, %ymm0
; AVX2-NEXT:    retq
  %i0 = insertelement <8 x i32> %x, i32 %s, i32 4
  %i1 = insertelement <8 x i32> %i0, i32 %s, i32 5
  ret <8 x i32> %i1
}

define <4 x i64> @insert_i64_two_elts_of_high_subvector(<4 x i64> %x, i64 %s) {
; AVX-LABEL: insert_i64_two_elts_of_high_subvector:
; AVX:       # %bb.0:
; AVX-NEXT:    vpinsrq $0, %rdi, %xmm0, %xmm1
; AVX-NEXT:    vpinsrq $1, %rdi, %xmm1, %xmm1
; AVX-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; AVX-NEXT:    retq
;
; AVX2-LABEL: insert_i64_two_elts_of_high_subvector:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpinsrq $0, %rdi, %xmm0, %xmm1
; AVX2-NEXT:    vpinsrq $1, %rdi, %xmm1, %xmm1
; AVX2-NEXT:    vinserti128 $1, %xmm1, %ymm0, %ymm0
; AVX2-NEXT:    retq
  %i0 = insertelement <4 x i64> %x, i64 %s, i32 2
  %i1 = insertelement <4 x i64> %i0, i64 %s, i32 3
  ret <4 x i64> %i1
}

; element insertion into two elements of low subvector

define <8 x float> @insert_f32_two_elts_of_low_subvector(<8 x float> %x, float %s) {
; ALL-LABEL: insert_f32_two_elts_of_low_subvector:
; ALL:       # %bb.0:
; ALL-NEXT:    vshufps {{.*#+}} xmm1 = xmm1[0,0],xmm0[2,3]
; ALL-NEXT:    vblendps {{.*#+}} ymm0 = ymm1[0,1,2,3],ymm0[4,5,6,7]
; ALL-NEXT:    retq
  %i0 = insertelement <8 x float> %x, float %s, i32 0
  %i1 = insertelement <8 x float> %i0, float %s, i32 1
  ret <8 x float> %i1
}

define <4 x double> @insert_f64_two_elts_of_low_subvector(<4 x double> %x, double %s) {
; ALL-LABEL: insert_f64_two_elts_of_low_subvector:
; ALL:       # %bb.0:
; ALL-NEXT:    vmovddup {{.*#+}} xmm1 = xmm1[0,0]
; ALL-NEXT:    vblendps {{.*#+}} ymm0 = ymm1[0,1,2,3],ymm0[4,5,6,7]
; ALL-NEXT:    retq
  %i0 = insertelement <4 x double> %x, double %s, i32 0
  %i1 = insertelement <4 x double> %i0, double %s, i32 1
  ret <4 x double> %i1
}

define <32 x i8> @insert_i8_two_elts_of_low_subvector(<32 x i8> %x, i8 %s) {
; AVX-LABEL: insert_i8_two_elts_of_low_subvector:
; AVX:       # %bb.0:
; AVX-NEXT:    vpinsrb $0, %edi, %xmm0, %xmm1
; AVX-NEXT:    vpinsrb $1, %edi, %xmm1, %xmm1
; AVX-NEXT:    vblendps {{.*#+}} ymm0 = ymm1[0,1,2,3],ymm0[4,5,6,7]
; AVX-NEXT:    retq
;
; AVX2-LABEL: insert_i8_two_elts_of_low_subvector:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpinsrb $0, %edi, %xmm0, %xmm1
; AVX2-NEXT:    vpinsrb $1, %edi, %xmm1, %xmm1
; AVX2-NEXT:    vpblendd {{.*#+}} ymm0 = ymm1[0,1,2,3],ymm0[4,5,6,7]
; AVX2-NEXT:    retq
  %i0 = insertelement <32 x i8> %x, i8 %s, i32 0
  %i1 = insertelement <32 x i8> %i0, i8 %s, i32 1
  ret <32 x i8> %i1
}

define <16 x i16> @insert_i16_two_elts_of_low_subvector(<16 x i16> %x, i16 %s) {
; AVX-LABEL: insert_i16_two_elts_of_low_subvector:
; AVX:       # %bb.0:
; AVX-NEXT:    vpinsrw $0, %edi, %xmm0, %xmm1
; AVX-NEXT:    vpinsrw $1, %edi, %xmm1, %xmm1
; AVX-NEXT:    vblendps {{.*#+}} ymm0 = ymm1[0,1,2,3],ymm0[4,5,6,7]
; AVX-NEXT:    retq
;
; AVX2-LABEL: insert_i16_two_elts_of_low_subvector:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpinsrw $0, %edi, %xmm0, %xmm1
; AVX2-NEXT:    vpinsrw $1, %edi, %xmm1, %xmm1
; AVX2-NEXT:    vpblendd {{.*#+}} ymm0 = ymm1[0,1,2,3],ymm0[4,5,6,7]
; AVX2-NEXT:    retq
  %i0 = insertelement <16 x i16> %x, i16 %s, i32 0
  %i1 = insertelement <16 x i16> %i0, i16 %s, i32 1
  ret <16 x i16> %i1
}

define <8 x i32> @insert_i32_two_elts_of_low_subvector(<8 x i32> %x, i32 %s) {
; AVX-LABEL: insert_i32_two_elts_of_low_subvector:
; AVX:       # %bb.0:
; AVX-NEXT:    vpinsrd $0, %edi, %xmm0, %xmm1
; AVX-NEXT:    vpinsrd $1, %edi, %xmm1, %xmm1
; AVX-NEXT:    vblendps {{.*#+}} ymm0 = ymm1[0,1,2,3],ymm0[4,5,6,7]
; AVX-NEXT:    retq
;
; AVX2-LABEL: insert_i32_two_elts_of_low_subvector:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vmovd %edi, %xmm1
; AVX2-NEXT:    vpblendd {{.*#+}} xmm1 = xmm1[0],xmm0[1,2,3]
; AVX2-NEXT:    vpinsrd $1, %edi, %xmm1, %xmm1
; AVX2-NEXT:    vpblendd {{.*#+}} ymm0 = ymm1[0,1,2,3],ymm0[4,5,6,7]
; AVX2-NEXT:    retq
  %i0 = insertelement <8 x i32> %x, i32 %s, i32 0
  %i1 = insertelement <8 x i32> %i0, i32 %s, i32 1
  ret <8 x i32> %i1
}

define <4 x i64> @insert_i64_two_elts_of_low_subvector(<4 x i64> %x, i64 %s) {
; AVX-LABEL: insert_i64_two_elts_of_low_subvector:
; AVX:       # %bb.0:
; AVX-NEXT:    vpinsrq $0, %rdi, %xmm0, %xmm1
; AVX-NEXT:    vpinsrq $1, %rdi, %xmm1, %xmm1
; AVX-NEXT:    vblendps {{.*#+}} ymm0 = ymm1[0,1,2,3],ymm0[4,5,6,7]
; AVX-NEXT:    retq
;
; AVX2-LABEL: insert_i64_two_elts_of_low_subvector:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpinsrq $0, %rdi, %xmm0, %xmm1
; AVX2-NEXT:    vpinsrq $1, %rdi, %xmm1, %xmm1
; AVX2-NEXT:    vpblendd {{.*#+}} ymm0 = ymm1[0,1,2,3],ymm0[4,5,6,7]
; AVX2-NEXT:    retq
  %i0 = insertelement <4 x i64> %x, i64 %s, i32 0
  %i1 = insertelement <4 x i64> %i0, i64 %s, i32 1
  ret <4 x i64> %i1
}
