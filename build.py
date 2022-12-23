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

def configure(root, path, build_path, config):
  print('>> Configure ({})'.format(config))

  cache_file = os.path.join(root, 'cache.cmake')

  command = 'cmake -S "{}" -B "{}" -C "{}" -DCMAKE_BUILD_TYPE={}'.format(path, build_path, cache_file, config)

  print('Command: {}'.format(command))
  os.system(command)
  print('\n')

def build(build_path, config):
  print('>> Build ({})'.format(config))
  targets = ["libclang", "install"]
  command = 'cmake --build "{}" --config {} --target {}'.format(build_path, config, ' '.join(targets))
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
  root = os.path.dirname(__file__)

  parser = argparse.ArgumentParser(description = "Build LLVM for Rift", formatter_class=argparse.ArgumentDefaultsHelpFormatter)
  parser.add_argument("--config", "-c", default="Release", help="Configuration to build LLVM in. Debug, Release, MinSizeRel or RelWithDebInfo")
  parser.add_argument("--build", "-b", default="build", help="Path where to build LLVM")
  parser.add_argument("--no-build", action='store_true', help="Should build be skipped?")
  parser.add_argument("--install", "-i", default=None, help="Path where to install build LLVM files. If none provided, install won't be run")
  parser.add_argument("--clean-build", action='store_true', help="Should build files be cleaned after LLVM is build and/or installed? Keeping build uses disk space but speeds up rebuilds of LLVM")
  args = parser.parse_args()

  install_dependencies()

  llvm_path = os.path.join(root, 'llvm/llvm')

  start_time = time.time()

  # Sanitize paths
  if not os.path.isabs(args.build):
    args.build = os.path.join(root, args.build)

  if not os.path.exists(args.build):
    os.makedirs(args.build)

  configure(root, llvm_path, args.build, args.config)

  if not args.no_build:
    build(args.build, args.config)

  if args.install:
    install(root, args.build, args.install, args.config)

  if args.clean_build:
    shutil.rmtree(args.build)

  print("Took {:.2f} seconds".format(time.time() - start_time))

if __name__ == "__main__":
   main(sys.argv[1:])
