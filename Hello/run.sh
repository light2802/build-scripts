#!/bin/bash

#!/bin/bash

set -e

CURRENT_DIR=$1
PREFIX="${CURRENT_DIR:=$(pwd)}"

EXAMPLE_PATH=${PREFIX}
BUILD_TYPE=Debug
PROJECT=examples
HPX_DIR=/work/aarya/hpx/cmake-install/Debug/lib64/cmake/HPX
LOG_FILE=${PREFIX}/logs/${PROJECT}-build-options.log

#sh ${PREFIX}/build-hpxmp.sh


mkdir -p ${PREFIX}
mkdir -p logs

cmake                                                                                           \
  -DCMAKE_BUILD_TYPE=${BUILD_TYPE}                                                              \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=ON                                                            \
  -DCMAKE_CXX_FLAGS="-std=c++17"                                                       \
  -DCMAKE_CXX_COMPILER=g++                                                                  \
  -DCMAKE_C_COMPILER=gcc                                                                      \
  -DHPX_DIR=${HPX_DIR}                                                                          \
  -DWITH_HPXC=ON                                                                                \
  -DOMP_LIB_PATH=/work/aarya/llvm-project/openmp/cmake-install-hpxmp/Debug/lib/libomp.so  \
  -Wdev -S ${EXAMPLE_PATH} -B ${EXAMPLE_PATH}/cmake-build-hpxmp/${BUILD_TYPE}\
  -DHPX_IGNORE_COMPILER_COMPATIBILITY=ON

cmake --build ${EXAMPLE_PATH}/cmake-build-hpxmp/${BUILD_TYPE}/ --parallel
cmake --install ${EXAMPLE_PATH}/cmake-build-hpxmp/${BUILD_TYPE}/ --prefix ${EXAMPLE_PATH}/cmake-install-hpxmp/${BUILD_TYPE}

