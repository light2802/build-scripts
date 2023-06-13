#!/bin/bash

CURRENT_DIR=$1
PREFIX="${CURRENT_DIR:=$(pwd)}"

LLVM_DIR=${PREFIX}/llvm-project
BUILD_TYPE=Debug

HPX_DIR=${PREFIX}/hpx/cmake-install/${BUILD_TYPE}/lib64/cmake/HPX
HPXC_DIR=${PREFIX}/hpxc/cmake-install/${BUILD_TYPE}

mkdir -p ${PREFIX}
if [ ! -d ${LLVM_DIR} ]; then
  git clone https://github.com/llvm/llvm-project.git ${LLVM_DIR}
fi
echo $HPX_DIR
cd ${LLVM_DIR}
cmake                                                                     \
  -DCMAKE_BUILD_TYPE=${BUILD_TYPE}                                        \
  -DHPXC_DIR=${HPXC_DIR}						  \
  -DHPX_DIR=${HPX_DIR}                                                    \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=ON                                      \
  -DCMAKE_CXX_FLAGS="-gdwarf-4 -std=c++17"                                          \
  -DCMAKE_CXX_COMPILER=clang++                                            \
  -DCMAKE_C_COMPILER=clang                                                \
  -DLLVM_ENABLE_PROJECTS='clang;clang-tools-extra;openmp;lldb'            \
  -Wdev -S ${LLVM_DIR}/llvm -B ${LLVM_DIR}/cmake-build/${BUILD_TYPE}	  \
  -DLIBOMP_OMPD_SUPPORT=OFF \
  -DCMAKE_VERBOSE_MAKEFILE:BOOL=OFF

cmake --build ${LLVM_DIR}/cmake-build/${BUILD_TYPE}/ --parallel 8
cmake --install ${LLVM_DIR}/cmake-build/${BUILD_TYPE}/ --prefix ${LLVM_DIR}/cmake-install/${BUILD_TYPE}

