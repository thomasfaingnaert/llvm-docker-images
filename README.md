# LLVM Docker Images

## Overview

This repository contains a Dockerfile to build Docker images containing LLVM and Clang.
The Dockerfile has the following build arguments:

- `BASE_IMAGE`: Base image to use for building and for the final image, e.g. `ubuntu:22.04`.
- `LLVM_VERSION`: The LLVM version to build. This can be a branch, tag, or commit hash.
- `BUILD_TYPE`: The CMake build type, e.g. `Release`, `Debug`, or `RelWithDebInfo`.
- `ASSERTIONS_ENABLED`: Whether to enable (`ON`) or disable (`OFF`) assertions.
- `LLVM_PROJECTS`: The list of LLVM projects to build, e.g. `clang;lldb`.
- `EXTRA_CMAKE_ARGUMENTS`: Extra arguments to pass to CMake. See https://llvm.org/docs/CMake.html.

## Published Docker images

This repository already contains some pre-built Docker images based on Ubuntu 22.04 LTS that you can pull.

They are named as follows: `ghcr.io/thomasfaingnaert/llvm-clang:<LLVM_VERSION>-Release[-asserts][-asan]`.
`LLVM_VERSION` is the version of LLVM (without the `llvmorg-` prefix), and the optional `-asserts` and `-asan` infixes represent a build with assertions and Address Sanitizer enabled, respectively.

For a full list of pre-built Docker images, see https://github.com/thomasfaingnaert/llvm-docker-images/pkgs/container/llvm-clang.
