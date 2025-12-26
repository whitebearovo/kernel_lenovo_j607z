#!/bin/bash

#edit by whiteberovo for mhr.ver 2025.12.16
#编译链 clang13.0.1 MAIN 分支 https://github.com/nzlnice/kernel_bulid.git
#下面是sh配置文件，仅参考 需根据实际修改
# 清理编译环境

#install requirements
sudo apt update
sudo apt install cpio bc flex ccache
#install old kmod
wget https://www.kernel.org/pub/linux/utils/kernel/kmod/kmod-26.tar.xz
tar -xf kmod-26.tar.xz
cd kmod-26
./configure --prefix=/usr --sysconfdir=/etc
make
sudo make install

make clean
make mrproper

# 设置工具链路径
OUT_DIR=out
export PATH=$PATH:/workspaces/kernel_lenovo_J607Z/buildtool/toolclang/clang-r428724/bin:/workspaces/kernel_lenovo_J607Z/buildtool/toolgcc/bin:/workspaces/kernel_lenovo_J607Z/buildtool/toolgcc/arm/bin
export ARCH=arm64
export CC=/workspaces/kernel_lenovo_J607Z/buildtool/toolclang/clang-r428724/bin/clang
export SUBARCH=arm64
export CLANG_TRIPLE=aarch64-linux-gnu-
export CROSS_COMPILE=/workspaces/kernel_lenovo_J607Z/buildtool/toolgcc/bin/aarch64-linux-android-
export CROSS_COMPILE_ARM32=/workspaces/kernel_lenovo_J607Z/buildtool/toolgcc/arm/bin/arm-linux-androideabi-

# LLVM 配置
export LLVM=1
export LLVM_IAS=1

# 工具链配置
export AR=/workspaces/kernel_lenovo_J607Z/buildtool/toolclang/clang-r428724/bin/llvm-ar
export HOSTCC=gcc
export HOSTCXX=/workspaces/kernel_lenovo_J607Z/buildtool/toolclang/clang-r428724/bin/clang++
export NM=/workspaces/kernel_lenovo_J607Z/buildtool/toolclang/clang-r428724/bin/llvm-nm
export OBJCOPY=/workspaces/kernel_lenovo_J607Z/buildtool/toolclang/clang-r428724/bin/llvm-objcopy
export OBJDUMP=/workspaces/kernel_lenovo_J607Z/buildtool/toolclang/clang-r428724/bin/llvm-objdump
export STRIP=/workspaces/kernel_lenovo_J607Z/buildtool/toolclang/clang-r428724/bin/llvm-strip
export LD=/workspaces/kernel_lenovo_J607Z/buildtool/toolclang/clang-r428724/bin/ld.lld
export DTC_EXT=/workspaces/kernel_lenovo_J607Z/buildtool/dtc

# Android内核特定配置
export PLATFORM_VERSION=12
export ANDROID_MAJOR_VERSION=s

# 构建信息
export KBUILD_BUILD_HOST=Mahiru-Codespace
export KBUILD_BUILD_USER=mahirunoinu

# 生成配置文件
make ARCH=arm64 O=$OUT_DIR CC=$CC vendor/arnoz_defconfig

ccache make ARCH=arm64 O=$OUT_DIR CC=$CC -j14 2>&1 | tee /workspaces/kernel_lenovo_J607Z/out/kernel_log.log

#！！！！！！！！！！！！！在输出的out文件夹执行！！！！！！！！！！
#sudo make ARCH=arm64 O=$OUT_DIR CC=$CC modules_install INSTALL_MOD_PATH=vendor最后在里面把ko后缀文件放vendor/lib/modules下即可否则无声音和旋转等重要功能