#!/usr/bin/env bash
set -Eeuo pipefail
set -x

# Download and compile LLVM
git clone --branch ${LLVM_VERSION} --depth 1 https://github.com/llvm/llvm-project
pushd llvm-project

mkdir build
cd build

CMAKE_CONFIGURATION=""

# Use lld for faster linking
CMAKE_CONFIGURATION="${CMAKE_CONFIGURATION} -DLLVM_USE_LINKER=lld"

# Set build type
CMAKE_CONFIGURATION="${CMAKE_CONFIGURATION} -DCMAKE_BUILD_TYPE=${BUILD_TYPE}"

# Enable assertions
CMAKE_CONFIGURATION="${CMAKE_CONFIGURATION} -DLLVM_ENABLE_ASSERTIONS=${ASSERTIONS_ENABLED}"

# Only build target correspondig to host architecture
CMAKE_CONFIGURATION="${CMAKE_CONFIGURATION} -DLLVM_TARGETS_TO_BUILD=host"

# Build and link against shared library (smaller binary size)
CMAKE_CONFIGURATION="${CMAKE_CONFIGURATION} -DLLVM_BUILD_LLVM_DYLIB=ON"
CMAKE_CONFIGURATION="${CMAKE_CONFIGURATION} -DLLVM_LINK_LLVM_DYLIB=ON"

# Build and install utility binaries (such as FileCheck)
CMAKE_CONFIGURATION="${CMAKE_CONFIGURATION} -DLLVM_BUILD_UTILS=ON"
CMAKE_CONFIGURATION="${CMAKE_CONFIGURATION} -DLLVM_INSTALL_UTILS=ON"

# Build extra projects
CMAKE_CONFIGURATION="${CMAKE_CONFIGURATION} -DLLVM_ENABLE_PROJECTS=$LLVM_PROJECTS"

# If building in Debug, use optimized TableGen to speed up build
if [[ "${BUILD_TYPE}" == "Debug" ]]; then

     CMAKE_CONFIGURATION="${CMAKE_CONFIGURATION} -DLLVM_OPTIMIZED_TABLEGEN=ON"
fi

# Set install prefix
CMAKE_CONFIGURATION="${CMAKE_CONFIGURATION} -DCMAKE_INSTALL_PREFIX=/opt/llvm"

# Extra arguments
CMAKE_CONFIGURATION="${CMAKE_CONFIGURATION} ${EXTRA_CMAKE_ARGUMENTS}"

cmake -GNinja ${CMAKE_CONFIGURATION} ../llvm

cmake --build .
cmake --build . --target install

popd
