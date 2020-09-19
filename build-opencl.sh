#!/bin/bash
ANDROID_CMAKE="home/jongminkim/Android/Sdk/cmake/3.10.2.4988404/bin/cmake"
ANDROID_TOOLCHAIN_FILE="/home/jongminkim/Android/Sdk/ndk/21.3.6528147/build/cmake/android.toolchain.cmake"
ANDROID_ABI="arm64-v8a"
ANDROID_API_LEVEL="26"
cd build
$ANDROID_CMAKE ../mixbench-opencl \ 
	-DCMAKE_TOOLCHAIN_FILE=$ANDROID_TOOLCHAIN_FILE \
	-DANDROID_ABI=$ANDROID_ABI \
	-DANDROID_NATIVE_API_LEVEL=$ANDROID_API_LEVEL
