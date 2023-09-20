#!/bin/bash

set -e

export AARCH64=true

export ROOT_DIR=$PWD
export TOOLCHAIN_DIR=$ROOT_DIR/Toolchain
export APP_DIR=$ROOT_DIR/App
export UBOOT_DIR=$ROOT_DIR/U-boot
export KERNEL_DIR=$ROOT_DIR/Kernel
export OPENSOURCE_DIR=$ROOT_DIR/Opensource
export ROOTFS_DIR=$ROOT_DIR/Rootfs
export RELEASE_DIR=$ROOT_DIR/Release
export ETC_DIR=$ROOT_DIR/Etc

cd $TOOLCHAIN_DIR && ./make.sh

if [ $AARCH64 = true ]; then
	export CROSS_COMPILE=$TOOLCHAIN_DIR/toolchain/aarch64/gcc-arm-10.3-2021.07-x86_64-aarch64-none-linux-gnu/bin/aarch64-none-linux-gnu-
	export CC=$TOOLCHAIN_DIR/toolchain/aarch64/gcc-arm-10.3-2021.07-x86_64-aarch64-none-linux-gnu/bin/aarch64-none-linux-gnu-gcc
	export CXX=$TOOLCHAIN_DIR/toolchain/aarch64/gcc-arm-10.3-2021.07-x86_64-aarch64-none-linux-gnu/bin/aarch64-none-linux-gnu-g++
	export STRIP=$TOOLCHAIN_DIR/toolchain/aarch64/gcc-arm-10.3-2021.07-x86_64-aarch64-none-linux-gnu/bin/aarch64-none-linux-gnu-strip
else
	export CROSS_COMPILE=$TOOLCHAIN_DIR/toolchain/arm/gcc-arm-10.3-2021.07-x86_64-arm-none-linux-gnueabihf/bin/arm-none-linux-gnueabihf-
	export CC=$TOOLCHAIN_DIR/toolchain/arm/gcc-arm-10.3-2021.07-x86_64-arm-none-linux-gnueabihf/bin/arm-none-linux-gnueabihf-gcc
	export CXX=$TOOLCHAIN_DIR/toolchain/arm/gcc-arm-10.3-2021.07-x86_64-arm-none-linux-gnueabihf/bin/arm-none-linux-gnueabihf-g++
	export STRIP=$TOOLCHAIN_DIR/toolchain/arm/gcc-arm-10.3-2021.07-x86_64-arm-none-linux-gnueabihf/bin/arm-none-linux-gnueabihf-strip
fi

export RS232_MQ=yes
export RNDIS_MQ=no

if [ $# = 0 ]; then
	cd $OPENSOURCE_DIR && ./make.sh
	cd $APP_DIR && ./make.sh
else
	if [ $1 = "clean" ]; then
		cd $APP_DIR && ./make.sh clean
	elif [ $1 = "U-boot" ] || [ $1 = "U-boot/" ]; then
		cd $UBOOT_DIR && ./make.sh $2
	elif [ $1 = "Kernel" ] || [ $1 = "Kernel/" ]; then
		cd $KERNEL_DIR && ./make.sh $2
	elif [ $1 = "Opensource" ] || [ $1 = "Opensource/" ]; then
		cd $OPENSOURCE_DIR && ./make.sh $2
	elif [ $1 = "Rootfs" ] || [ $1 = "Rootfs/" ]; then
		cd $ROOTFS_DIR && ./make.sh $2
	else
		echo "build Invalid"
	fi
fi
