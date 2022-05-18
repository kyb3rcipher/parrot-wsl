#!/bin/bash
parrot_version=5.0.1

# Color variables
resetColor="\e[0m\e[0m"
redColor="\e[0;31m\e[1m"
cyanColor="\e[01;96m\e[1m"
whiteColor="\e[01;37m\e[1m"
greenColor="\e[0;32m\e[1m"
yellowColor="\e[0;33m\e[1m"
dot="${redColor}[${yellowColor}*${redColor}]${resetColor}"

# Check root privileges
[ "$EUID" -ne 0 ] && echo -e "$dot ${yellowColor}Please run with ${redColor}root ${yellowColor}or use ${greenColor}sudo${resetColor} " && exit

# Create work dirs and delete them if they exists
[ -d out_dir/x64 ] && rm -rf out_dir/x64
[ -d work_dir/x64 ] && rm -rf work_dir/x64
mkdir out_dir/x64
mkdir work_dir/x64
cd work_dir/x64

# Download launcher and uncompress
wget https://github.com/yuk7/wsldl/releases/download/21082800/icons.zip -q --show-progress
unzip icons.zip Debian.exe
mv Debian.exe Launcher.exe

# Download Parrot rootfs and configure
wget https://deb.parrotsec.org/parrot/iso/$parrot_version/Parrot-rootfs-${parrot_version}_$architecture.tar.xz -q --show-progress
tar -xpf Parrot-rootfs-${parrot_version}_$architecture.tar.xz && mv parrot-$architecture rootfs
chroot rootfs apt update
cd rootfs; tar -zcpf ../rootfs.tar.gz `ls`
chown `id -un` ../rootfs.tar.gz

# Create ziproot for release
cd ..
mkdir ziproot
cp Launcher.exe ziproot/Parrot.exe
cp rootfs.tar.gz ziproot
#compress folder ziproot for release
cd ziproot
bsdtar -a -cf ../../../out_dir/x64/ParrotWSL-$parrot_version-x64.zip *
