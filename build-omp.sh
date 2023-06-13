#!/bin/bash

CURRENT_DIR=$1
PREFIX="${CURRENT_DIR:=$(pwd)}"

BUILD_TYPE=Debug
LLVM_DIR=${PREFIX}/llvm-project
LLVM_VERSION=16.0.5
OMP_DIR=${LLVM_DIR}/openmp
PROJECT=omp
LOG_FILE=${PREFIX}/logs/${PROJECT}-build-options.log


mkdir -p ${PREFIX}

# Logging the configuration
CONFIG="cmake
  -DCMAKE_BUILD_TYPE=${BUILD_TYPE}
  -DCMAKE_VERBOSE_MAKEFILE=ON
  -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
  -DCMAKE_CXX_FLAGS="-std=c++17"
  -DCMAKE_CXX_COMPILER=g++
  -DCMAKE_C_COMPILER=gcc
  -Wdev -S ${OMP_DIR} -B ${OMP_DIR}/cmake-build-${PROJECT}/${BUILD_TYPE}
  # -DKA_TRACE=ON

cmake --build ${OMP_DIR}/cmake-build-${PROJECT}/${BUILD_TYPE}/ --parallel
cmake --install ${OMP_DIR}/cmake-build-${PROJECT}/${BUILD_TYPE}/ --prefix ${OMP_DIR}/cmake-install-${PROJECT}/${BUILD_TYPE}
"

echo "${CONFIG}"

if [ ! -d ${LLVM_DIR} ]; then
  git clone --depth=1 -b llvmorg-$LLVM_VERSION git@github.com:llvm/llvm-project.git ${LLVM_DIR}
fi

cd ${OMP_DIR}
cmake                                \
  -DCMAKE_BUILD_TYPE=${BUILD_TYPE}   \
  -DCMAKE_VERBOSE_MAKEFILE=ON        \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
  -DCMAKE_CXX_FLAGS="-std=c++17"     \
  -DCMAKE_CXX_COMPILER=g++       \
  -DCMAKE_C_COMPILER=gcc           \
  -Wdev -S ${OMP_DIR} -B ${OMP_DIR}/cmake-build-${PROJECT}/${BUILD_TYPE}
  # -DKA_TRACE=ON                      \

cmake --build ${OMP_DIR}/cmake-build-${PROJECT}/${BUILD_TYPE}/ --parallel
cmake --install ${OMP_DIR}/cmake-build-${PROJECT}/${BUILD_TYPE}/ --prefix ${OMP_DIR}/cmake-install-${PROJECT}/${BUILD_TYPE}

# Writing the config to file.
mkdir -p logs
LOG="$(date); running $0 from $(pwd)" >> ${LOG_FILE}
LINE="~"
for i in $(seq 2 ${#LOG}); do
  LINE+="~"
done
echo ${LOG} >> ${LOG_FILE}
echo ${LINE} >> ${LOG_FILE}
echo "${CONFIG}" >> ${LOG_FILE}
echo >> ${LOG_FILE}

