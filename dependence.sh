#!/bin/bash

if [ "$(uname -r)" !=  "5.12.0-xrp+" ]; then
    printf "Not in XRP kernel. Please run the following commands to boot into XRP kernel:\n"
    printf "    sudo grub-reboot \"Advanced options for Ubuntu>Ubuntu, with Linux 5.12.0-xrp+\"\n"
    printf "    sudo reboot\n"
    exit 1
fi

# Install build dependencies
printf "Installing dependencies...\n"
sudo apt-get update
sudo apt-get install -y gcc-multilib clang llvm libelf-dev libdwarf-dev cmake

wget -O /tmp/libbpf0_0.1.0-1_amd64.deb https://old-releases.ubuntu.com/ubuntu/pool/universe/libb/libbpf/libbpf0_0.1.0-1_amd64.deb
wget -O /tmp/libbpf-dev_0.1.0-1_amd64.deb https://old-releases.ubuntu.com/ubuntu/pool/universe/libb/libbpf/libbpf-dev_0.1.0-1_amd64.deb
wget -O /tmp/dwarves_1.17-1_amd64.deb https://old-releases.ubuntu.com/ubuntu/pool/universe/d/dwarves-dfsg/dwarves_1.17-1_amd64.deb

sudo dpkg -i /tmp/libbpf0_0.1.0-1_amd64.deb
sudo dpkg -i /tmp/libbpf-dev_0.1.0-1_amd64.deb
sudo dpkg -i /tmp/dwarves_1.17-1_amd64.deb

#根据脚本的相对路径获取绝对路径
# SCRIPT_PATH=`realpath $0`
#根据绝对路径获取目录
# BASE_DIR=`dirname $SCRIPT_PATH`
# BUILD_PATH="$BASE_DIR/build"

# 默认设备 nvme0n1，如果第一个参数不设置设备的话。
# DEV_NAME="/dev/nvme0n1"
# if [ ! -z $1 ]; then
#     DEV_NAME=$1
# fi
# printf "DEV_NAME=$DEV_NAME\n"

