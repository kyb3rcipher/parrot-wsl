#!/bin/bash
# ParrotOS rootfs builder for WSL
# (execute me on linux)
parrot_version=5.0.1
build_dir=$(pwd)
tmp_dir=$(mktemp -d)
tmp_dir_arm=$(mktemp -d)

# Colors variables
resetColor="\e[0m\e[0m"
redColor="\e[0;31m\e[1m"
cyanColor="\e[01;96m\e[1m"
whiteColor="\e[01;37m\e[1m"
greenColor="\e[0;32m\e[1m"
yellowColor="\e[0;33m\e[1m"
dot="${redColor}[${yellowColor}*${redColor}]${resetColor}"

# Check root privileges
[ "$EUID" -ne 0 ] && echo -e "$dot ${yellowColor}Please run with ${redColor}root ${yellowColor}or use ${greenColor}sudo${resetColor} " && exit

# banner
banner(){
clear
echo -e "$cyanColor ╔═╗┌─┐┬─┐┬─┐┌─┐┌┬┐  ╦ ╦╔═╗╦    ╦═╗╔═╗╔═╗╔╦╗╔═╗╔═╗  ╔╗ ╦ ╦╦╦  ╔╦╗╔═╗╦═╗"
echo -e "$cyanColor ╠═╝├─┤├┬┘├┬┘│ │ │   ║║║╚═╗║    ╠╦╝║ ║║ ║ ║ ╠╣ ╚═╗  ╠╩╗║ ║║║   ║║║╣ ╠╦╝"
echo -e "$cyanColor ╩  ┴ ┴┴└─┴└─└─┘ ┴   ╚╩╝╚═╝╩═╝  ╩╚═╚═╝╚═╝ ╩ ╚  ╚═╝  ╚═╝╚═╝╩╩═╝═╩╝╚═╝╩╚═"
echo -e " ${whiteColor}Version: $parrot_version$resetColor"
echo -e " ${whiteColor}Architecture: $architecture$resetColor\n"
sleep 2
}

function system_setup(){
echo 'system setup'
}

# x64 (amd64)
architecture="x64 (amd64)"
banner
# Download rootfs
echo -e "$dot$yellowColor Downloading x64 rootfs...$resetColor"
cd $tmp_dir
wget https://deb.parrotsec.org/parrot/iso/$parrot_version/Parrot-rootfs-${parrot_version}_amd64.tar.xz -q --show-progress
tar -xpf Parrot-rootfs-${parrot_version}_amd64.tar.xz && mv parrot-amd64 rootfs

# Configure rootfs
echo -e "$dot$greenColor Configuring x64 rootfs...$resetColor"
system_setup

# Compress rootfs and move to build directory
echo -e "$dot$yellowColor Compressing and moving x64 rootfs...$resetColor"
cd rootfs
tar --ignore-failed-read -czvf $tmp_dir/install.tar.gz *
mkdir -p $build_dir/x64
mv $tmp_dir/install.tar.gz $build_dir/x64
cd $build_dir

# ARM (arm64)
architecture="ARM (arm64)"
banner
# Download arm rootfs
echo -e "$dot$yellowColor Downloading arm rootfs...$resetColor"
cd $tmp_dir_arm
wget https://deb.parrotsec.org/parrot/iso/$parrot_version/Parrot-rootfs-${parrot_version}_arm64.tar.xz -q --show-progress
tar -xpf Parrot-rootfs-${parrot_version}_arm64.tar.xz && mv parrot-arm64 rootfs

# Configure arm rootfs
echo -e "$dot$greenColor Configuring arm rootfs...$resetColor"
system_setup

# Compress arm rootfs and move to build directory
echo -e "$dot$yellowColor Compressing and moving arm rootfs...$resetColor"
cd rootfs
tar --ignore-failed-read -czvf $tmp_dir_arm/install.tar.gz *
mkdir -p $build_dir/ARM64
mv $tmp_dir_arm/install.tar.gz $build_dir/ARM64
cd $build_dir

echo -e "\n$dot$greenColor All done.$resetColor"
