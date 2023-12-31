#!/usr/bin/env python3

import argparse
import docker
import json
import time
from tqdm import tqdm
from tqdm.contrib import itertools

client = docker.from_env()

parser = argparse.ArgumentParser(
        prog='build-all-variants',
        description='Build all variants of LLVM images for a given version')

parser.add_argument('llvm_version', help='The LLVM version to use. This can be anything that git clone --branch accepts, i.e. a branch, commit, tag, ...')
parser.add_argument('-v', '--verbose', action='store_true')

args = parser.parse_args()

LLVM_VERSION = args.llvm_version
FRIENDLY_LLVM_VERSION = LLVM_VERSION.removeprefix('llvmorg-')
LLVM_PROJECTS = 'clang'

for BUILD_TYPE, \
    (ASSERTIONS_ENABLED, assertions_infix), \
    (EXTRA_CMAKE_ARGUMENTS, san_infix) in itertools.product(
            ['Release'],
            [('OFF', ''), ('ON', '-asserts')],
            [('', ''), ('-DLLVM_USE_SANITIZER=Address', '-asan')]
            ):

    image_name = f'ghcr.io/thomasfaingnaert/llvm-clang:{FRIENDLY_LLVM_VERSION}-{BUILD_TYPE}{assertions_infix}{san_infix}'

    tqdm.write(f'Building image {image_name}...')

    start = time.time()

    for line in client.api.build(
            path='./docker/',
            tag=image_name,
            rm=True,
            buildargs={
                'BASE_IMAGE': 'ubuntu:22.04',
                'LLVM_VERSION': LLVM_VERSION,
                'BUILD_TYPE': BUILD_TYPE,
                'ASSERTIONS_ENABLED': ASSERTIONS_ENABLED,
                'LLVM_PROJECTS': LLVM_PROJECTS,
                'EXTRA_CMAKE_ARGUMENTS': EXTRA_CMAKE_ARGUMENTS,
            },
            decode=True):
        if args.verbose:
            if 'stream' in line:
                tqdm.write(line['stream'], end='')

    tqdm.write(f'Pushing image {image_name}...')

    for line in client.images.push(image_name, stream=True, decode=True):
        if args.verbose:
            if 'status' in line:
                tqdm.write(str(line['status']), end='')
            if 'progress' in line:
                tqdm.write(' ' + str(line['progress']), end='')

            tqdm.write('')

    end = time.time()

    tqdm.write(f'Took {end-start} second(s).')
