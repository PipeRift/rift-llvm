import os

root = os.getcwd()
llvm_path = os.path.join(root, 'llvm')
host_path = os.path.join(root, 'build')

print(">> Configure LLVM")
os.system('cmake -S "{0}" -B "{1}" -DLLVM_ENABLE_PROJECTS="lld;clang" \
  -DLLVM_ENABLE_LIBXML2=OFF \
  -DLLVM_INCLUDE_TESTS=OFF \
  -DLLVM_INCLUDE_GO_TESTS=OFF \
  -DLLVM_INCLUDE_EXAMPLES=OFF \
  -DLLVM_INCLUDE_BENCHMARKS=OFF \
  -DLLVM_ENABLE_BINDINGS=OFF \
  -DLLVM_ENABLE_OCAMLDOC=OFF \
  -DLLVM_ENABLE_Z3_SOLVER=OFF \
  -DLLVM_BUILD_TOOLS=OFF \
  -DCLANG_BUILD_TOOLS=OFF \
  -DCLANG_INCLUDE_DOCS=OFF \
  -DLLVM_INCLUDE_DOCS=OFF \
  -DCMAKE_BUILD_TYPE=Release'.format(llvm_path, host_path))

print("\n>> Build LLVM")
os.system('cmake --build "{0}" --config Release --target install'.format(host_path))
