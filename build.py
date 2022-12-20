import os
import sys, getopt
import shutil
import time
import argparse


def install_dependencies():
  if sys.platform == "linux" or sys.platform == "linux2":
    print(">> Install dependencies")
    try:
      os.system('sudo apt -qq install -y libedit-dev')
    except:
      exit("Failed to install dependencies")

def configure(path, build_path, projects, config, targets):
  print('>> Configure ({})'.format(config))

  command = 'cmake -S "{}" -B "{}" -DCMAKE_BUILD_TYPE={} \
    -DLLVM_ENABLE_PROJECTS="{}" \
    -DLLVM_BUILD_TOOLS=OFF \
    -DLLVM_ENABLE_LLD=ON \
    -DLLVM_ENABLE_LIBXML2=OFF \
    -DLLVM_ENABLE_BINDINGS=OFF \
    -DLLVM_ENABLE_OCAMLDOC=OFF \
    -DLLVM_ENABLE_Z3_SOLVER=OFF \
    -DLLVM_ENABLE_WARNINGS=OFF \
    -DLLVM_INCLUDE_BENCHMARKS=OFF \
    -DLLVM_INCLUDE_DOCS=OFF \
    -DLLVM_INCLUDE_EXAMPLES=OFF \
    -DLLVM_INCLUDE_TESTS=OFF \
    -DLLVM_INCLUDE_TOOLS=OFF \
    -DLLVM_USE_CRT_RELEASE=MT \
    -DLLVM_USE_CRT_DEBUG=MTd \
    -DCLANG_BUILD_TOOLS=OFF \
    -DCLANG_INCLUDE_DOCS=OFF'.format(path, build_path, config, ';'.join(projects))
  if targets:
    command += ' -DLLVM_TARGETS_TO_BUILD="{}"'.format(';'.join(targets))

  print('Command: {}'.format(command))
  os.system(command)
  print('\n')

def build(build_path, config):
  print('>> Build ({})'.format(config))
  command = 'cmake --build "{}" --config {} --target install'.format(build_path, config)
  print('Command: {}'.format(command))
  os.system(command)
  print('\n')


def install(root, build_path, install_path, config):
  print(">> Install LLVM")
  if not os.path.isabs(install_path):
    install_path = os.path.join(root, install_path)
  install_path = os.path.join(install_path, config)
  os.system('cmake -DCMAKE_INSTALL_PREFIX={} -DBUILD_TYPE={} -P {}/cmake_install.cmake'.format(install_path, config, build_path))
  print('\n')

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

  install_dependencies()

  # Validate parameters
  args.projects = args.projects.split(',')
  args.targets = args.targets.split(',')

  llvm_path = os.path.join(root, 'llvm/llvm')

  start_time = time.time()

  # Sanitize paths
  if not os.path.isabs(args.build):
    args.build = os.path.join(root, args.build)

  if not os.path.exists(args.build):
    os.makedirs(args.build)

  configure(llvm_path, args.build, args.projects, args.config, args.targets)

  if not args.no_build:
    build(args.build, args.config)

  if args.install:
    install(root, args.build, args.install, args.config)

  if args.clean_build:
    shutil.rmtree(args.build)

  print("Took {:.2f} seconds".format(time.time() - start_time))

if __name__ == "__main__":
   main(sys.argv[1:])
