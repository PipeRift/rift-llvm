import os
import sys, getopt


def main(argv):
  help = 'test.py -c <Debug|Release|MinSizeRel|RelWithDebInfo>'
  try:
    opts, args = getopt.getopt(argv,"hc:",["config="])
  except getopt.GetoptError:
    print(help)
    sys.exit(2)

  config = 'Release'
  for opt, arg in opts:
    if opt == '-h':
        print(help)
        sys.exit()
    elif opt in ("-c", "--config"):
        config = arg


  root = os.getcwd()
  llvm_path = os.path.join(root, 'llvm')
  host_path = os.path.join(root, 'build')

  print(">> Configure LLVM ({})".format(config))
  os.system('cmake -S "{}" -B "{}" -DLLVM_ENABLE_PROJECTS="lld;clang" \
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
    -DCMAKE_BUILD_TYPE={}'.format(llvm_path, host_path, config))

  print("\n>> Build LLVM")
  os.system('cmake --build "{}" --config {} --target install'.format(host_path, config))

if __name__ == "__main__":
   main(sys.argv[1:])