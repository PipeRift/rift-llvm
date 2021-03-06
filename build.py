import os
import sys, getopt
import shutil
import time
import argparse


def main(argv):
  root = os.getcwd()

  parser = argparse.ArgumentParser(description = "Build LLVM for Rift", formatter_class=argparse.ArgumentDefaultsHelpFormatter)
  parser.add_argument("--config", "-c", default="Release", help="Configuration to build LLVM in. Debug, Release, MinSizeRel or RelWithDebInfo")
  parser.add_argument("--build", "-b", default="build", help="Path where to build LLVM")
  parser.add_argument("--no-build", action='store_true', help="Should build be skipped?")
  parser.add_argument("--install", "-i", default=None, help="Path where to install build LLVM files. If none provided, install won't be run")
  parser.add_argument("--projects", default="clang,lld", help="List of LLVM projects to include on the build")
  parser.add_argument("--targets", default="X86,ARM,AArch64,RISCV", help="List of LLVM targets to include on the build. 'all' will build all targets")
  parser.add_argument("--clean-build", action='store_true', help="Should build files be cleaned after LLVM is build and/or installed? Keeping build uses disk space but speeds up rebuilds of LLVM")
  args = parser.parse_args()

  # Validate parameters
  args.projects = args.projects.split(',')
  args.targets = args.targets.split(',')

  llvm_path = os.path.join(root, 'llvm/llvm')

  start_time = time.time()
  print(">> Configure LLVM ({})".format(args.config))
  if not os.path.isabs(args.build):
    args.build = os.path.join(root, args.build)
  args.build = os.path.join(args.build, args.config)
  targetsParameter = ""
  if args.targets:
    targetsParameter = '-DLLVM_TARGETS_TO_BUILD="{}"'.format(';'.join(args.targets))
  generateCommand = 'cmake -S "{}" -B "{}" -DLLVM_ENABLE_PROJECTS="{}" \
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
    -DCMAKE_BUILD_TYPE={} {}'.format(llvm_path, args.build, ';'.join(args.projects), args.config, targetsParameter)
  print("Running: \n  {}".format(generateCommand))
  os.system(generateCommand)


  print("\n>> Build LLVM")
  if not args.no_build:
    os.system('cmake --build "{}" --config {} --target install'.format(args.build, args.config))

  if args.install:
    print("\n>> Install LLVM")
    if not os.path.isabs(args.install):
      args.install = os.path.join(root, args.install)
    args.install = os.path.join(args.install, args.config)
    os.system('cmake -DCMAKE_INSTALL_PREFIX={} -P {}/cmake_install.cmake'.format(args.install, args.build))

  if args.clean_build:
    shutil.rmtree(args.build)

  print("Took {:.2f} seconds".format(time.time() - start_time))

if __name__ == "__main__":
   main(sys.argv[1:])
