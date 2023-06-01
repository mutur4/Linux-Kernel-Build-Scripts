#! /usr/bin/bash 


BUSYBOX_VERSION=1.32.0


init(){
        wget -q -c https://busybox.net/downloads/busybox-$BUSYBOX_VERSION.tar.bz2
        [ -e busybox-$BUSYBOX_VERSION.tar.bz2 ] && tar xjf busybox-$BUSYBOX_VERSION.tar.bz2


        printf "BB Build...\n"

        make -C busybox-$BUSYBOX_VERSION defconfig
        sed -i 's/# CONFIG_STATIC is not set/CONFIG_STATIC=y/g' busybox-$BUSYBOX_VERSION/.config

        make -C busybox-$BUSYBOX_VERSION -j16
        make -C busybox-$BUSYBOX_VERSION install

        printf "Fs Buildz..\n";

        mkdir -p ./rootfs/{bin,sbin,etc,proc,sys,usr/bin,root,home/ffs}
        cp -ar ./busybox-$BUSYBOX_VERSION/_install/* rootfs

        echo "Building Modules..\n"

        [ -e vuln.ko ] || make

        cp vuln.ko rootfs
}

init
