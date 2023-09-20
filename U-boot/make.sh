#!/bin/bash

if [ ! -d "u-boot" ]; then
	tar xf dist/u-boot-px30.tgz -C ./
	cd u-boot && patch -p1 <../dist/u-boot-px30.patch
	cd ..
fi

if [ "$#" = 0 ]; then
	echo "build U-boot"
	cd u-boot && ./make.sh px30 CROSS_COMPILE=$CROSS_COMPILE
	cp -f uboot.img $RELEASE_DIR
	cp -f trust.img $RELEASE_DIR
	cp -f *_loader_*.bin $RELEASE_DIR/MiniLoaderAll.bin
	cd ..
else
	if [ "$1" = "clean" ]; then
		echo "clean U-boot"
		make clean -C u-boot
	fi
fi
