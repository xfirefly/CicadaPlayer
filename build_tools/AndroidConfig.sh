#!/usr/bin/env bash

# Android build configuration for NDK R27+
# Uses the unified LLVM toolchain

function android_init_env(){
    local ABI=$1
    NDK_V=21 # Minimum supported API level (default)
    
    # Determine HOST
    UNAME=$(uname)
    if [ "$UNAME" = "Darwin" ]; then
        HOST=darwin
    else
        HOST=linux
    fi

    if [ -z "${ANDROID_NDK}" ]; then
        echo "ANDROID_NDK not set"
        return 1
    fi

    TOOLCHAIN_BIN=${ANDROID_NDK}/toolchains/llvm/prebuilt/${HOST}-x86_64/bin
    SYSTEM_ROOT=${ANDROID_NDK}/toolchains/llvm/prebuilt/${HOST}-x86_64/sysroot

    case "$ABI" in
        "armeabi-v7a")
            CPU_ARCH=arm
            TARGET=armv7a-linux-androideabi
            CROSS_COMPILE=arm-linux-androideabi
            CPU_FLAGS="-march=armv7-a -mfloat-abi=softfp -mfpu=vfpv3-d16 -mthumb -fPIC"
            CPU_LD_FLAGS=""
            NEON_SUPPORT="TRUE"
            ;;
        "arm64-v8a")
            CPU_ARCH=arm64
            TARGET=aarch64-linux-android
            CROSS_COMPILE=aarch64-linux-android
            CPU_FLAGS="-fPIC"
            CPU_LD_FLAGS=""
            NEON_SUPPORT="TRUE"
            ;;
        "x86")
            CPU_ARCH=x86
            TARGET=i686-linux-android
            CROSS_COMPILE=i686-linux-android
            CPU_FLAGS="-fPIC"
            CPU_LD_FLAGS=""
            NEON_SUPPORT="FALSE"
            ;;
        "x86_64")
            CPU_ARCH=x86_64
            TARGET=x86_64-linux-android
            CROSS_COMPILE=x86_64-linux-android
            CPU_FLAGS="-fPIC"
            CPU_LD_FLAGS=""
            NEON_SUPPORT="FALSE"
            ;;
        *)
            echo "Unsupported Android ABI: $ABI"
            return 1
            ;;
    esac

    # Set compilers and tools
    CC=${TOOLCHAIN_BIN}/${TARGET}${NDK_V}-clang
    CXX=${TOOLCHAIN_BIN}/${TARGET}${NDK_V}-clang++
    AS=${CC}
    AR=${TOOLCHAIN_BIN}/llvm-ar
    NM=${TOOLCHAIN_BIN}/llvm-nm
    RANLIB=${TOOLCHAIN_BIN}/llvm-ranlib
    STRIP=${TOOLCHAIN_BIN}/llvm-strip
    
    # Export for other scripts
    export CC CXX AS AR NM RANLIB STRIP
    export TARGET_OS=Android
    export SYSTEM_ROOT
    export CPU_ARCH ABI NDK_V
    
    echo "Android environment initialized for $ABI (API $NDK_V)"
    echo "CC: $CC"
}

# Compatibility wrapper
function android_init_env_clang(){
    android_init_env "$1"
}

# Legacy arch-specific inits (now just call the main one or set variables)
function android_armv7_a_init_env(){
    android_init_env "armeabi-v7a"
}

function android_arm64_v8a_init_env(){
    android_init_env "arm64-v8a"
}

