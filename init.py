import os
import sys, getopt
import shutil
import argparse


def main(argv):
  root = os.path.dirname(__file__)

  parser = argparse.ArgumentParser(description = "Init Rift LLVM toolchain", formatter_class=argparse.ArgumentDefaultsHelpFormatter)
  args = parser.parse_args()

  os.chdir(root)
  os.system('git submodule update --init --recursive')

if __name__ == "__main__":
   main(sys.argv[1:])
