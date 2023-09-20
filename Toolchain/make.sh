#!/bin/bash

if [ ! -d "toolchain" ]; then
	tar xf dist/gcc-arm-10.3-2021.07-x86_64-arm-none-linux-gnu.tgz -C ./
fi
