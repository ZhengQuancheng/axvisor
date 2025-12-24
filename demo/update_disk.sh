#!/bin/sh

if [ $# -ne 1 ]; then
    printf "Usage: ./update.sh [userapp path]\n"
    exit
fi

FILE=$1

if [ ! -f $FILE ]; then
    printf "File '$FILE' doesn't exist!\n"
    exit
fi

if [ ! -f ./rootfs.img ]; then
    printf "rootfs.img doesn't exist! Please 'make disk_img'\n"
    exit
fi

printf "Write file '$FILE' into rootfs.img\n"

mkdir -p ./mnt
sudo mount ./rootfs.img ./mnt
sudo mkdir -p ./mnt/sbin
sudo cp $FILE ./mnt/sbin
sudo umount ./mnt
rm -rf mnt
