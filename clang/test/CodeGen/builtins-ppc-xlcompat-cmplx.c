// NOTE: Assertions have been autogenerated by utils/update_cc_test_checks.py
// REQUIRES: powerpc-registered-target
// RUN: %clang_cc1 -triple powerpc64-unknown-linux-gnu \
// RUN:    -emit-llvm %s -o -  -target-cpu pwr7 | FileCheck %s --check-prefix=64BIT
// RUN: %clang_cc1 -triple powerpc64le-unknown-linux-gnu \
// RUN:   -emit-llvm %s -o -  -target-cpu pwr8 | FileCheck %s --check-prefix=64BITLE
// RUN: %clang_cc1 -triple powerpc64-unknown-aix \
// RUN:    -emit-llvm %s -o -  -target-cpu pwr7 | FileCheck %s --check-prefix=64BITAIX
// RUN: %clang_cc1 -triple powerpc-unknown-linux-gnu \
// RUN:    -emit-llvm %s -o -  -target-cpu pwr7 | FileCheck %s --check-prefix=32BIT
// RUN: %clang_cc1 -triple powerpcle-unknown-linux-gnu \
// RUN:   -emit-llvm %s -o -  -target-cpu pwr8 | FileCheck %s --check-prefix=32BITLE
// RUN: %clang_cc1 -triple powerpc-unknown-aix \
// RUN:    -emit-llvm %s -o -  -target-cpu pwr7 | FileCheck %s --check-prefix=32BITAIX

// 64BIT-LABEL: @testcmplx(
// 64BIT-NEXT:  entry:
// 64BIT-NEXT:    [[RETVAL:%.*]] = alloca { double, double }, align 8
// 64BIT-NEXT:    [[REAL_ADDR:%.*]] = alloca double, align 8
// 64BIT-NEXT:    [[IMAG_ADDR:%.*]] = alloca double, align 8
// 64BIT-NEXT:    store double [[REAL:%.*]], double* [[REAL_ADDR]], align 8
// 64BIT-NEXT:    store double [[IMAG:%.*]], double* [[IMAG_ADDR]], align 8
// 64BIT-NEXT:    [[TMP0:%.*]] = load double, double* [[REAL_ADDR]], align 8
// 64BIT-NEXT:    [[TMP1:%.*]] = load double, double* [[IMAG_ADDR]], align 8
// 64BIT-NEXT:    [[RETVAL_REALP:%.*]] = getelementptr inbounds { double, double }, { double, double }* [[RETVAL]], i32 0, i32 0
// 64BIT-NEXT:    [[RETVAL_IMAGP:%.*]] = getelementptr inbounds { double, double }, { double, double }* [[RETVAL]], i32 0, i32 1
// 64BIT-NEXT:    store double [[TMP0]], double* [[RETVAL_REALP]], align 8
// 64BIT-NEXT:    store double [[TMP1]], double* [[RETVAL_IMAGP]], align 8
// 64BIT-NEXT:    [[TMP2:%.*]] = load { double, double }, { double, double }* [[RETVAL]], align 8
// 64BIT-NEXT:    ret { double, double } [[TMP2]]
//
// 64BITLE-LABEL: @testcmplx(
// 64BITLE-NEXT:  entry:
// 64BITLE-NEXT:    [[RETVAL:%.*]] = alloca { double, double }, align 8
// 64BITLE-NEXT:    [[REAL_ADDR:%.*]] = alloca double, align 8
// 64BITLE-NEXT:    [[IMAG_ADDR:%.*]] = alloca double, align 8
// 64BITLE-NEXT:    store double [[REAL:%.*]], double* [[REAL_ADDR]], align 8
// 64BITLE-NEXT:    store double [[IMAG:%.*]], double* [[IMAG_ADDR]], align 8
// 64BITLE-NEXT:    [[TMP0:%.*]] = load double, double* [[REAL_ADDR]], align 8
// 64BITLE-NEXT:    [[TMP1:%.*]] = load double, double* [[IMAG_ADDR]], align 8
// 64BITLE-NEXT:    [[RETVAL_REALP:%.*]] = getelementptr inbounds { double, double }, { double, double }* [[RETVAL]], i32 0, i32 0
// 64BITLE-NEXT:    [[RETVAL_IMAGP:%.*]] = getelementptr inbounds { double, double }, { double, double }* [[RETVAL]], i32 0, i32 1
// 64BITLE-NEXT:    store double [[TMP0]], double* [[RETVAL_REALP]], align 8
// 64BITLE-NEXT:    store double [[TMP1]], double* [[RETVAL_IMAGP]], align 8
// 64BITLE-NEXT:    [[TMP2:%.*]] = load { double, double }, { double, double }* [[RETVAL]], align 8
// 64BITLE-NEXT:    ret { double, double } [[TMP2]]
//
// 64BITAIX-LABEL: @testcmplx(
// 64BITAIX-NEXT:  entry:
// 64BITAIX-NEXT:    [[RETVAL:%.*]] = alloca { double, double }, align 4
// 64BITAIX-NEXT:    [[REAL_ADDR:%.*]] = alloca double, align 8
// 64BITAIX-NEXT:    [[IMAG_ADDR:%.*]] = alloca double, align 8
// 64BITAIX-NEXT:    store double [[REAL:%.*]], double* [[REAL_ADDR]], align 8
// 64BITAIX-NEXT:    store double [[IMAG:%.*]], double* [[IMAG_ADDR]], align 8
// 64BITAIX-NEXT:    [[TMP0:%.*]] = load double, double* [[REAL_ADDR]], align 8
// 64BITAIX-NEXT:    [[TMP1:%.*]] = load double, double* [[IMAG_ADDR]], align 8
// 64BITAIX-NEXT:    [[RETVAL_REALP:%.*]] = getelementptr inbounds { double, double }, { double, double }* [[RETVAL]], i32 0, i32 0
// 64BITAIX-NEXT:    [[RETVAL_IMAGP:%.*]] = getelementptr inbounds { double, double }, { double, double }* [[RETVAL]], i32 0, i32 1
// 64BITAIX-NEXT:    store double [[TMP0]], double* [[RETVAL_REALP]], align 4
// 64BITAIX-NEXT:    store double [[TMP1]], double* [[RETVAL_IMAGP]], align 4
// 64BITAIX-NEXT:    [[TMP2:%.*]] = load { double, double }, { double, double }* [[RETVAL]], align 4
// 64BITAIX-NEXT:    ret { double, double } [[TMP2]]
//
// 32BIT-LABEL: @testcmplx(
// 32BIT-NEXT:  entry:
// 32BIT-NEXT:    [[REAL_ADDR:%.*]] = alloca double, align 8
// 32BIT-NEXT:    [[IMAG_ADDR:%.*]] = alloca double, align 8
// 32BIT-NEXT:    store double [[REAL:%.*]], double* [[REAL_ADDR]], align 8
// 32BIT-NEXT:    store double [[IMAG:%.*]], double* [[IMAG_ADDR]], align 8
// 32BIT-NEXT:    [[TMP0:%.*]] = load double, double* [[REAL_ADDR]], align 8
// 32BIT-NEXT:    [[TMP1:%.*]] = load double, double* [[IMAG_ADDR]], align 8
// 32BIT-NEXT:    [[AGG_RESULT_REALP:%.*]] = getelementptr inbounds { double, double }, { double, double }* [[AGG_RESULT:%.*]], i32 0, i32 0
// 32BIT-NEXT:    [[AGG_RESULT_IMAGP:%.*]] = getelementptr inbounds { double, double }, { double, double }* [[AGG_RESULT]], i32 0, i32 1
// 32BIT-NEXT:    store double [[TMP0]], double* [[AGG_RESULT_REALP]], align 8
// 32BIT-NEXT:    store double [[TMP1]], double* [[AGG_RESULT_IMAGP]], align 8
// 32BIT-NEXT:    [[AGG_RESULT_REALP1:%.*]] = getelementptr inbounds { double, double }, { double, double }* [[AGG_RESULT]], i32 0, i32 0
// 32BIT-NEXT:    [[AGG_RESULT_REAL:%.*]] = load double, double* [[AGG_RESULT_REALP1]], align 8
// 32BIT-NEXT:    [[AGG_RESULT_IMAGP2:%.*]] = getelementptr inbounds { double, double }, { double, double }* [[AGG_RESULT]], i32 0, i32 1
// 32BIT-NEXT:    [[AGG_RESULT_IMAG:%.*]] = load double, double* [[AGG_RESULT_IMAGP2]], align 8
// 32BIT-NEXT:    [[AGG_RESULT_REALP3:%.*]] = getelementptr inbounds { double, double }, { double, double }* [[AGG_RESULT]], i32 0, i32 0
// 32BIT-NEXT:    [[AGG_RESULT_IMAGP4:%.*]] = getelementptr inbounds { double, double }, { double, double }* [[AGG_RESULT]], i32 0, i32 1
// 32BIT-NEXT:    store double [[AGG_RESULT_REAL]], double* [[AGG_RESULT_REALP3]], align 8
// 32BIT-NEXT:    store double [[AGG_RESULT_IMAG]], double* [[AGG_RESULT_IMAGP4]], align 8
// 32BIT-NEXT:    ret void
//
// 32BITLE-LABEL: @testcmplx(
// 32BITLE-NEXT:  entry:
// 32BITLE-NEXT:    [[REAL_ADDR:%.*]] = alloca double, align 8
// 32BITLE-NEXT:    [[IMAG_ADDR:%.*]] = alloca double, align 8
// 32BITLE-NEXT:    store double [[REAL:%.*]], double* [[REAL_ADDR]], align 8
// 32BITLE-NEXT:    store double [[IMAG:%.*]], double* [[IMAG_ADDR]], align 8
// 32BITLE-NEXT:    [[TMP0:%.*]] = load double, double* [[REAL_ADDR]], align 8
// 32BITLE-NEXT:    [[TMP1:%.*]] = load double, double* [[IMAG_ADDR]], align 8
// 32BITLE-NEXT:    [[AGG_RESULT_REALP:%.*]] = getelementptr inbounds { double, double }, { double, double }* [[AGG_RESULT:%.*]], i32 0, i32 0
// 32BITLE-NEXT:    [[AGG_RESULT_IMAGP:%.*]] = getelementptr inbounds { double, double }, { double, double }* [[AGG_RESULT]], i32 0, i32 1
// 32BITLE-NEXT:    store double [[TMP0]], double* [[AGG_RESULT_REALP]], align 8
// 32BITLE-NEXT:    store double [[TMP1]], double* [[AGG_RESULT_IMAGP]], align 8
// 32BITLE-NEXT:    [[AGG_RESULT_REALP1:%.*]] = getelementptr inbounds { double, double }, { double, double }* [[AGG_RESULT]], i32 0, i32 0
// 32BITLE-NEXT:    [[AGG_RESULT_REAL:%.*]] = load double, double* [[AGG_RESULT_REALP1]], align 8
// 32BITLE-NEXT:    [[AGG_RESULT_IMAGP2:%.*]] = getelementptr inbounds { double, double }, { double, double }* [[AGG_RESULT]], i32 0, i32 1
// 32BITLE-NEXT:    [[AGG_RESULT_IMAG:%.*]] = load double, double* [[AGG_RESULT_IMAGP2]], align 8
// 32BITLE-NEXT:    [[AGG_RESULT_REALP3:%.*]] = getelementptr inbounds { double, double }, { double, double }* [[AGG_RESULT]], i32 0, i32 0
// 32BITLE-NEXT:    [[AGG_RESULT_IMAGP4:%.*]] = getelementptr inbounds { double, double }, { double, double }* [[AGG_RESULT]], i32 0, i32 1
// 32BITLE-NEXT:    store double [[AGG_RESULT_REAL]], double* [[AGG_RESULT_REALP3]], align 8
// 32BITLE-NEXT:    store double [[AGG_RESULT_IMAG]], double* [[AGG_RESULT_IMAGP4]], align 8
// 32BITLE-NEXT:    ret void
//
// 32BITAIX-LABEL: @testcmplx(
// 32BITAIX-NEXT:  entry:
// 32BITAIX-NEXT:    [[RETVAL:%.*]] = alloca { double, double }, align 4
// 32BITAIX-NEXT:    [[REAL_ADDR:%.*]] = alloca double, align 8
// 32BITAIX-NEXT:    [[IMAG_ADDR:%.*]] = alloca double, align 8
// 32BITAIX-NEXT:    store double [[REAL:%.*]], double* [[REAL_ADDR]], align 8
// 32BITAIX-NEXT:    store double [[IMAG:%.*]], double* [[IMAG_ADDR]], align 8
// 32BITAIX-NEXT:    [[TMP0:%.*]] = load double, double* [[REAL_ADDR]], align 8
// 32BITAIX-NEXT:    [[TMP1:%.*]] = load double, double* [[IMAG_ADDR]], align 8
// 32BITAIX-NEXT:    [[RETVAL_REALP:%.*]] = getelementptr inbounds { double, double }, { double, double }* [[RETVAL]], i32 0, i32 0
// 32BITAIX-NEXT:    [[RETVAL_IMAGP:%.*]] = getelementptr inbounds { double, double }, { double, double }* [[RETVAL]], i32 0, i32 1
// 32BITAIX-NEXT:    store double [[TMP0]], double* [[RETVAL_REALP]], align 4
// 32BITAIX-NEXT:    store double [[TMP1]], double* [[RETVAL_IMAGP]], align 4
// 32BITAIX-NEXT:    [[TMP2:%.*]] = load { double, double }, { double, double }* [[RETVAL]], align 4
// 32BITAIX-NEXT:    ret { double, double } [[TMP2]]
//
double _Complex testcmplx(double real, double imag) {
  return __cmplx(real, imag);
}

// 64BIT-LABEL: @testcmplxf(
// 64BIT-NEXT:  entry:
// 64BIT-NEXT:    [[RETVAL:%.*]] = alloca { float, float }, align 4
// 64BIT-NEXT:    [[REAL_ADDR:%.*]] = alloca float, align 4
// 64BIT-NEXT:    [[IMAG_ADDR:%.*]] = alloca float, align 4
// 64BIT-NEXT:    store float [[REAL:%.*]], float* [[REAL_ADDR]], align 4
// 64BIT-NEXT:    store float [[IMAG:%.*]], float* [[IMAG_ADDR]], align 4
// 64BIT-NEXT:    [[TMP0:%.*]] = load float, float* [[REAL_ADDR]], align 4
// 64BIT-NEXT:    [[TMP1:%.*]] = load float, float* [[IMAG_ADDR]], align 4
// 64BIT-NEXT:    [[RETVAL_REALP:%.*]] = getelementptr inbounds { float, float }, { float, float }* [[RETVAL]], i32 0, i32 0
// 64BIT-NEXT:    [[RETVAL_IMAGP:%.*]] = getelementptr inbounds { float, float }, { float, float }* [[RETVAL]], i32 0, i32 1
// 64BIT-NEXT:    store float [[TMP0]], float* [[RETVAL_REALP]], align 4
// 64BIT-NEXT:    store float [[TMP1]], float* [[RETVAL_IMAGP]], align 4
// 64BIT-NEXT:    [[TMP2:%.*]] = load { float, float }, { float, float }* [[RETVAL]], align 4
// 64BIT-NEXT:    ret { float, float } [[TMP2]]
//
// 64BITLE-LABEL: @testcmplxf(
// 64BITLE-NEXT:  entry:
// 64BITLE-NEXT:    [[RETVAL:%.*]] = alloca { float, float }, align 4
// 64BITLE-NEXT:    [[REAL_ADDR:%.*]] = alloca float, align 4
// 64BITLE-NEXT:    [[IMAG_ADDR:%.*]] = alloca float, align 4
// 64BITLE-NEXT:    store float [[REAL:%.*]], float* [[REAL_ADDR]], align 4
// 64BITLE-NEXT:    store float [[IMAG:%.*]], float* [[IMAG_ADDR]], align 4
// 64BITLE-NEXT:    [[TMP0:%.*]] = load float, float* [[REAL_ADDR]], align 4
// 64BITLE-NEXT:    [[TMP1:%.*]] = load float, float* [[IMAG_ADDR]], align 4
// 64BITLE-NEXT:    [[RETVAL_REALP:%.*]] = getelementptr inbounds { float, float }, { float, float }* [[RETVAL]], i32 0, i32 0
// 64BITLE-NEXT:    [[RETVAL_IMAGP:%.*]] = getelementptr inbounds { float, float }, { float, float }* [[RETVAL]], i32 0, i32 1
// 64BITLE-NEXT:    store float [[TMP0]], float* [[RETVAL_REALP]], align 4
// 64BITLE-NEXT:    store float [[TMP1]], float* [[RETVAL_IMAGP]], align 4
// 64BITLE-NEXT:    [[TMP2:%.*]] = load { float, float }, { float, float }* [[RETVAL]], align 4
// 64BITLE-NEXT:    ret { float, float } [[TMP2]]
//
// 64BITAIX-LABEL: @testcmplxf(
// 64BITAIX-NEXT:  entry:
// 64BITAIX-NEXT:    [[RETVAL:%.*]] = alloca { float, float }, align 4
// 64BITAIX-NEXT:    [[REAL_ADDR:%.*]] = alloca float, align 4
// 64BITAIX-NEXT:    [[IMAG_ADDR:%.*]] = alloca float, align 4
// 64BITAIX-NEXT:    store float [[REAL:%.*]], float* [[REAL_ADDR]], align 4
// 64BITAIX-NEXT:    store float [[IMAG:%.*]], float* [[IMAG_ADDR]], align 4
// 64BITAIX-NEXT:    [[TMP0:%.*]] = load float, float* [[REAL_ADDR]], align 4
// 64BITAIX-NEXT:    [[TMP1:%.*]] = load float, float* [[IMAG_ADDR]], align 4
// 64BITAIX-NEXT:    [[RETVAL_REALP:%.*]] = getelementptr inbounds { float, float }, { float, float }* [[RETVAL]], i32 0, i32 0
// 64BITAIX-NEXT:    [[RETVAL_IMAGP:%.*]] = getelementptr inbounds { float, float }, { float, float }* [[RETVAL]], i32 0, i32 1
// 64BITAIX-NEXT:    store float [[TMP0]], float* [[RETVAL_REALP]], align 4
// 64BITAIX-NEXT:    store float [[TMP1]], float* [[RETVAL_IMAGP]], align 4
// 64BITAIX-NEXT:    [[TMP2:%.*]] = load { float, float }, { float, float }* [[RETVAL]], align 4
// 64BITAIX-NEXT:    ret { float, float } [[TMP2]]
//
// 32BIT-LABEL: @testcmplxf(
// 32BIT-NEXT:  entry:
// 32BIT-NEXT:    [[REAL_ADDR:%.*]] = alloca float, align 4
// 32BIT-NEXT:    [[IMAG_ADDR:%.*]] = alloca float, align 4
// 32BIT-NEXT:    store float [[REAL:%.*]], float* [[REAL_ADDR]], align 4
// 32BIT-NEXT:    store float [[IMAG:%.*]], float* [[IMAG_ADDR]], align 4
// 32BIT-NEXT:    [[TMP0:%.*]] = load float, float* [[REAL_ADDR]], align 4
// 32BIT-NEXT:    [[TMP1:%.*]] = load float, float* [[IMAG_ADDR]], align 4
// 32BIT-NEXT:    [[AGG_RESULT_REALP:%.*]] = getelementptr inbounds { float, float }, { float, float }* [[AGG_RESULT:%.*]], i32 0, i32 0
// 32BIT-NEXT:    [[AGG_RESULT_IMAGP:%.*]] = getelementptr inbounds { float, float }, { float, float }* [[AGG_RESULT]], i32 0, i32 1
// 32BIT-NEXT:    store float [[TMP0]], float* [[AGG_RESULT_REALP]], align 4
// 32BIT-NEXT:    store float [[TMP1]], float* [[AGG_RESULT_IMAGP]], align 4
// 32BIT-NEXT:    [[AGG_RESULT_REALP1:%.*]] = getelementptr inbounds { float, float }, { float, float }* [[AGG_RESULT]], i32 0, i32 0
// 32BIT-NEXT:    [[AGG_RESULT_REAL:%.*]] = load float, float* [[AGG_RESULT_REALP1]], align 4
// 32BIT-NEXT:    [[AGG_RESULT_IMAGP2:%.*]] = getelementptr inbounds { float, float }, { float, float }* [[AGG_RESULT]], i32 0, i32 1
// 32BIT-NEXT:    [[AGG_RESULT_IMAG:%.*]] = load float, float* [[AGG_RESULT_IMAGP2]], align 4
// 32BIT-NEXT:    [[AGG_RESULT_REALP3:%.*]] = getelementptr inbounds { float, float }, { float, float }* [[AGG_RESULT]], i32 0, i32 0
// 32BIT-NEXT:    [[AGG_RESULT_IMAGP4:%.*]] = getelementptr inbounds { float, float }, { float, float }* [[AGG_RESULT]], i32 0, i32 1
// 32BIT-NEXT:    store float [[AGG_RESULT_REAL]], float* [[AGG_RESULT_REALP3]], align 4
// 32BIT-NEXT:    store float [[AGG_RESULT_IMAG]], float* [[AGG_RESULT_IMAGP4]], align 4
// 32BIT-NEXT:    ret void
//
// 32BITLE-LABEL: @testcmplxf(
// 32BITLE-NEXT:  entry:
// 32BITLE-NEXT:    [[REAL_ADDR:%.*]] = alloca float, align 4
// 32BITLE-NEXT:    [[IMAG_ADDR:%.*]] = alloca float, align 4
// 32BITLE-NEXT:    store float [[REAL:%.*]], float* [[REAL_ADDR]], align 4
// 32BITLE-NEXT:    store float [[IMAG:%.*]], float* [[IMAG_ADDR]], align 4
// 32BITLE-NEXT:    [[TMP0:%.*]] = load float, float* [[REAL_ADDR]], align 4
// 32BITLE-NEXT:    [[TMP1:%.*]] = load float, float* [[IMAG_ADDR]], align 4
// 32BITLE-NEXT:    [[AGG_RESULT_REALP:%.*]] = getelementptr inbounds { float, float }, { float, float }* [[AGG_RESULT:%.*]], i32 0, i32 0
// 32BITLE-NEXT:    [[AGG_RESULT_IMAGP:%.*]] = getelementptr inbounds { float, float }, { float, float }* [[AGG_RESULT]], i32 0, i32 1
// 32BITLE-NEXT:    store float [[TMP0]], float* [[AGG_RESULT_REALP]], align 4
// 32BITLE-NEXT:    store float [[TMP1]], float* [[AGG_RESULT_IMAGP]], align 4
// 32BITLE-NEXT:    [[AGG_RESULT_REALP1:%.*]] = getelementptr inbounds { float, float }, { float, float }* [[AGG_RESULT]], i32 0, i32 0
// 32BITLE-NEXT:    [[AGG_RESULT_REAL:%.*]] = load float, float* [[AGG_RESULT_REALP1]], align 4
// 32BITLE-NEXT:    [[AGG_RESULT_IMAGP2:%.*]] = getelementptr inbounds { float, float }, { float, float }* [[AGG_RESULT]], i32 0, i32 1
// 32BITLE-NEXT:    [[AGG_RESULT_IMAG:%.*]] = load float, float* [[AGG_RESULT_IMAGP2]], align 4
// 32BITLE-NEXT:    [[AGG_RESULT_REALP3:%.*]] = getelementptr inbounds { float, float }, { float, float }* [[AGG_RESULT]], i32 0, i32 0
// 32BITLE-NEXT:    [[AGG_RESULT_IMAGP4:%.*]] = getelementptr inbounds { float, float }, { float, float }* [[AGG_RESULT]], i32 0, i32 1
// 32BITLE-NEXT:    store float [[AGG_RESULT_REAL]], float* [[AGG_RESULT_REALP3]], align 4
// 32BITLE-NEXT:    store float [[AGG_RESULT_IMAG]], float* [[AGG_RESULT_IMAGP4]], align 4
// 32BITLE-NEXT:    ret void
//
// 32BITAIX-LABEL: @testcmplxf(
// 32BITAIX-NEXT:  entry:
// 32BITAIX-NEXT:    [[RETVAL:%.*]] = alloca { float, float }, align 4
// 32BITAIX-NEXT:    [[REAL_ADDR:%.*]] = alloca float, align 4
// 32BITAIX-NEXT:    [[IMAG_ADDR:%.*]] = alloca float, align 4
// 32BITAIX-NEXT:    store float [[REAL:%.*]], float* [[REAL_ADDR]], align 4
// 32BITAIX-NEXT:    store float [[IMAG:%.*]], float* [[IMAG_ADDR]], align 4
// 32BITAIX-NEXT:    [[TMP0:%.*]] = load float, float* [[REAL_ADDR]], align 4
// 32BITAIX-NEXT:    [[TMP1:%.*]] = load float, float* [[IMAG_ADDR]], align 4
// 32BITAIX-NEXT:    [[RETVAL_REALP:%.*]] = getelementptr inbounds { float, float }, { float, float }* [[RETVAL]], i32 0, i32 0
// 32BITAIX-NEXT:    [[RETVAL_IMAGP:%.*]] = getelementptr inbounds { float, float }, { float, float }* [[RETVAL]], i32 0, i32 1
// 32BITAIX-NEXT:    store float [[TMP0]], float* [[RETVAL_REALP]], align 4
// 32BITAIX-NEXT:    store float [[TMP1]], float* [[RETVAL_IMAGP]], align 4
// 32BITAIX-NEXT:    [[TMP2:%.*]] = load { float, float }, { float, float }* [[RETVAL]], align 4
// 32BITAIX-NEXT:    ret { float, float } [[TMP2]]
//
float _Complex testcmplxf(float real, float imag) {
  return __cmplxf(real, imag);
}
