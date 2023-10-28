ARG BASE_IMAGE
FROM $BASE_IMAGE AS builder

# Install dependencies
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    cmake                                                               \
    clang                                                               \
    git                                                                 \
    lld                                                                 \
    ninja-build                                                         \
    python3                                                             \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /tmp

COPY build-llvm.sh .

# A branch, commit, tag, ... e.g. llvmorg-17.0.3
ARG LLVM_VERSION=main

# For example, Release or Debug
ARG BUILD_TYPE=Release

# Whether to enable assertions: ON or OFF.
ARG ASSERTIONS_ENABLED=ON

# LLVM projects to build, e.g. clang;lldb.
ARG LLVM_PROJECTS=clang

# Extra CMake arguments
ARG EXTRA_CMAKE_ARGUMENTS

ENV CC=/usr/bin/clang
ENV CXX=/usr/bin/clang++
ENV LLVM_VERSION=$LLVM_VERSION
ENV BUILD_TYPE=$BUILD_TYPE
ENV ASSERTIONS_ENABLED=$ASSERTIONS_ENABLED
ENV LLVM_PROJECTS=$LLVM_PROJECTS
ENV EXTRA_CMAKE_ARGUMENTS=$EXTRA_CMAKE_ARGUMENTS

RUN ./build-llvm.sh

FROM $BASE_IMAGE

COPY --from=builder /opt/llvm /opt/llvm
ENV LLVM_ROOT=/opt/llvm
ENV PATH=$LLVM_ROOT/bin:$PATH

LABEL org.opencontainers.image.source https://github.com/thomasfaingnaert/llvm-docker-images
