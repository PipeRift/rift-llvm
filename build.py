import os
import sys, getopt


def main(argv):
  help = 'test.py -c <Debug|Release|MinSizeRel|RelWithDebInfo>'
  try:
    opts, args = getopt.getopt(argv,"hc:",["config="])
  except getopt.GetoptError:
    print(help)
    sys.exit(2)

  root = os.getcwd()
  llvm_path = os.path.join(root, 'llvm/llvm')
  build_path = os.path.join(root, 'build')
  install_path = os.path.join(root, 'install')
  config = 'Release'

  for opt, arg in opts:
    if opt == '-h':
        print(help)
        sys.exit()
    elif opt in ("-c", "--config"):
        config = arg
    elif opt in ("-b", "--build-path"):
        build_path = arg
    elif opt in ("-i", "--install-path"):
        install_path = arg

  print(">> Configure LLVM ({})".format(config))
  os.system('cmake -S "{}" -B "{}" -DLLVM_ENABLE_PROJECTS="lld;clang" \
    -DLLVM_BUILD_TOOLS=OFF \
    -DLLVM_ENABLE_LIBXML2=OFF \
    -DLLVM_ENABLE_BINDINGS=OFF \
    -DLLVM_ENABLE_OCAMLDOC=OFF \
    -DLLVM_ENABLE_Z3_SOLVER=OFF \
    -DLLVM_INCLUDE_BENCHMARKS=OFF \
    -DLLVM_INCLUDE_DOCS=OFF \
    -DLLVM_INCLUDE_EXAMPLES=OFF \
    -DLLVM_INCLUDE_GO_TESTS=OFF \
    -DLLVM_INCLUDE_TESTS=OFF \
    -DLLVM_USE_CRT_RELEASE=MD \
    -DLLVM_USE_CRT_DEBUG=MDd \
    -DCLANG_BUILD_TOOLS=OFF \
    -DCLANG_INCLUDE_DOCS=OFF \
    -DCMAKE_BUILD_TYPE={}'.format(llvm_path, build_path, config))

  print("\n>> Build LLVM")
  os.system('cmake --build "{}" --config {} --target install'.format(build_path, config))

  print("\n>> Install LLVM")
  os.system('cmake -DCMAKE_INSTALL_PREFIX={} -P {}/cmake_install.cmake'.format(install_path, build_path))


if __name__ == "__main__":
   main(sys.argv[1:])