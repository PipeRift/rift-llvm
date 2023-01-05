import os
import subprocess
import sys
import shutil
import time
import argparse


def install_dependencies():
  if sys.platform == "linux":
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
  subprocess.run(command, shell=True, check=True)
  print('\n')

def build(build_path, config):
  print('>> Build ({})'.format(config))
  command = 'cmake --build "{}" --config {} --target install'.format(build_path, config)
  print('Command: {}'.format(command))
  subprocess.run(command, shell=True, check=False)

  # Extra targets
  #command = 'cmake --build "{}" --config {} --target libclang'.format(build_path, config)
  #print('Command: {}'.format(command))
  #subprocess.run(command, shell=True, check=False)
  print('\n')

def install(install_path, build_path, config):
  print(">> Install LLVM")
  command = 'cmake --install {} --config {} --prefix {}'.format(build_path, config, install_path)
  print('Command: {}'.format(command))
  subprocess.run(command, shell=True, check=True)
  print('\n')


def main(argv):
  root = os.path.dirname(__file__)

  parser = argparse.ArgumentParser(description = "Build LLVM for Rift", formatter_class=argparse.ArgumentDefaultsHelpFormatter)
  parser.add_argument("--config", "-c", default="Release", help="Configuration to build LLVM in. Debug, Release, MinSizeRel or RelWithDebInfo")
  parser.add_argument("--build", "-b", default="build", help="Path where to build LLVM")
  parser.add_argument("--no-build", action='store_true', help="Should build be skipped?")
  parser.add_argument("--install", "-i", default=None, help="Should llvm build be installed in install directory?")
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
    if not os.path.isabs(args.install):
      args.install = os.path.join(root, args.install)
    args.install = os.path.join(args.install, args.config)
    install(args.install, args.build, args.config)

  if args.clean_build:
    shutil.rmtree(args.build)

  print("Took {:.2f} seconds".format(time.time() - start_time))

if __name__ == "__main__":
   main(sys.argv[1:])
