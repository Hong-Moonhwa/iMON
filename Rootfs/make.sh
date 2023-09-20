#!/bin/bash

if [ ! -d "rootfs" ]; then
	tar xf dist/rootfs.tgz -C ./
fi

if [ "$#" = 0 ]; then
	echo "build Rootfs"

	dd if=/dev/null of=rootfs.ext2 bs=1kx1k seek=400
	mkfs.ext4 rootfs.ext2
	
	if [ ! -d "mnt" ]; then
		mkdir mnt
	fi

	sudo mount -t ext4 rootfs.ext2 mnt
	sudo cp -rf rootfs/* mnt
	sudo umount mnt

	mv rootfs.ext2 $RELEASE_DIR/rootfs.img
	rm -rf mnt

	echo "build Recovery"

	ROOTFS_IMG=dist/recovery.cpio.gz
	KERNEL_IMG=$KERNEL_DIR/kernel/arch/arm64/boot/Image.lz4
	KERNEL_DTB=$KERNEL_DIR/kernel/resource.img
	TARGET_IMG=recovery.img

	if [ ! -f "$KERNEL_IMG" ]; then
		echo "kernel doesn't exist, recovery build fail!"
		exit
	fi

	$KERNEL_DIR/kernel/scripts/mkbootimg --kernel "$KERNEL_IMG" --ramdisk "$ROOTFS_IMG" --second "$KERNEL_DTB" -o "$TARGET_IMG"
	mv $TARGET_IMG $RELEASE_DIR

	echo "build Etc"

	cp $ETC_DIR/rockchip/parameter.txt $RELEASE_DIR
	cp $ETC_DIR/rockchip/misc/wipe_all-misc.img $RELEASE_DIR/misc.img
else
	if [ "$1" = "clean" ]; then
		echo "clean Rootfs"
		rm -rf rootfs
		rm -rf rootfs.ext2
		rm -rf mnt
	fi
fi
