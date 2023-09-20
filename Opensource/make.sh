#!/bin/bash

if [ ! -d "json-c" ]; then
	tar xf dist/json-c.tgz -C ./
fi

if [ ! -d "cJSON" ]; then
	tar xf dist/cJSON.tgz -C ./
fi

if [ ! -d "coreJSON" ]; then
	tar xf dist/coreJSON.tgz -C ./
fi

if [ "$#" = 0 ]; then
	cd json-c && ./make.sh
	cd ..
else
	if [ "$1" = "clean" ]; then
		cd json-c && ./make.sh clean
		cd ..
	fi
fi

if [ $RNDIS_MQ = "yes" ]; then
	if [ ! -d "aws-iot" ]; then
		git clone -b v1.24.3 --recursive https://github.com/aws/aws-iot-device-sdk-cpp-v2.git aws-iot
		cd aws-iot
		git submodule update --init --recursive
		cd ..
	fi

	if [ "$#" = 0 ]; then
		cd aws-iot
		
		if [ ! -d "build" ]; then
			mkdir build
			cd build
			cmake -DCMAKE_SYSTEM_NAME=Linux -DCMAKE_SYSTEM_PROCESSOR=arm -DBUILD_SHARED_LIBS=ON -DCMAKE_INSTALL_PREFIX=$OPENSOURCE_DIR/aws-iot/install -DCMAKE_BUILD_TYPE=Debug ..
			cmake --build . --target install
			cd ..

			cd samples/fleet_provisioning/fleet_provisioning
			mkdir build
			cd build
			cmake -DCMAKE_SYSTEM_NAME=Linux -DCMAKE_SYSTEM_PROCESSOR=arm -DBUILD_SHARED_LIBS=ON -DCMAKE_INSTALL_PREFIX=$OPENSOURCE_DIR/aws-iot/install -DCMAKE_BUILD_TYPE=Debug ..
			cmake --build . --target install
			cd ../../../../

			cd samples/pub_sub/basic_pub_sub
			mkdir build
			cd build
			cmake -DCMAKE_SYSTEM_NAME=Linux -DCMAKE_SYSTEM_PROCESSOR=arm -DBUILD_SHARED_LIBS=ON -DCMAKE_INSTALL_PREFIX=$OPENSOURCE_DIR/aws-iot/install -DCMAKE_BUILD_TYPE=Debug ..
			cmake --build . --config Debug
			cp -f basic-pub-sub $OPENSOURCE_DIR/aws-iot/install/bin
			cd ../../../../
		fi

: <<'END'
		cd samples/fleet_provisioning/fleet_provisioning
		cd build
		cmake -DCMAKE_SYSTEM_NAME=Linux -DCMAKE_SYSTEM_PROCESSOR=arm -DBUILD_SHARED_LIBS=ON -DCMAKE_INSTALL_PREFIX=$OPENSOURCE_DIR/aws-iot/install -DCMAKE_BUILD_TYPE=Debug ..
		cmake --build . --target install
		cd ../../../../

		cd samples/pub_sub/basic_pub_sub
		cd build
		cmake -DCMAKE_SYSTEM_NAME=Linux -DCMAKE_SYSTEM_PROCESSOR=arm -DBUILD_SHARED_LIBS=ON -DCMAKE_INSTALL_PREFIX=$OPENSOURCE_DIR/aws-iot/install -DCMAKE_BUILD_TYPE=Debug ..
		cmake --build . --config Debug
		cp -f basic-pub-sub $OPENSOURCE_DIR/aws-iot/install/bin
		cd ../../../../
END

		cp -rf install/lib $RELEASE_DIR
		cp -rf install/lib $ROOTFS_DIR/rootfs/root
		cd ..
	else
		if [ "$1" = "clean" ]; then
			rm -rf aws-iot/build
			rm -rf aws-iot/samples/identity/fleet_provisioning/build
			rm -rf aws-iot/samples/identity/basic_pub_sub/build
			rm -rf aws-iot/install
		fi
	fi
fi
