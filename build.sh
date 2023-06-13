#!/bin/bash

rm -rf hpx/cmake-build/
rm -rf hpxc/cmake-build/
rm -rf llvm-project/openmp/cmake-build-hpxmp/

./build-hpx.sh
./build-hpxc.sh
./build-hpxmp.sh
