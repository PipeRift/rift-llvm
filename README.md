# LLVM build environment for Rift
[![build](https://github.com/PipeRift/rift-llvm/actions/workflows/build.yml/badge.svg)](https://github.com/PipeRift/rift-llvm/actions/workflows/build.yml) ![Release](https://img.shields.io/github/v/release/piperift/rift-llvm)

This repository contains a reproducible LLVM environment build for [Rift](https://github.com/PipeRift/rift)


## Prerequisites
In order to build LLVM you will need a Cpp compiler

## Setup

To build, simply run `build.py` using python:
```bash
py build.py
```

## Differences to llvm-project
Only kept clang, lld and llvm folders
