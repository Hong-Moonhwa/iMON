#!/bin/bash

if [ ! -d "kernel" ]; then
	tar xf dist/linux-5.10-px30.tgz -C ./
	cd kernel && patch -p1 <../dist/linux-5.10-px30.patch
	make ARCH=arm64 px30_linux_defconfig
	cd ..
fi

if [ "$#" = 0 ]; then
	echo "build Kernel"
	make -C kernel ARCH=arm64 -j8
	make -C kernel ARCH=arm64 -j8 rk3358-evb-ddr3-v10-linux.img
	cp -f kernel/zboot.img $RELEASE_DIR/boot.img
else
	if [ "$1" = "clean" ]; then
		echo "clean Kernel"
		make clean -C kernel
	fi
fi
