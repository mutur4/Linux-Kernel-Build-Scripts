#! /usr/bin/bash

# Coompile the C script first 

gcc -o chall chall.c -static -masm=intel || exit 1

# Copy this in the rootfs 

cp ./chall ./rootfs

# archive the file system 

[ -e rootfs.cpio.gz ] && rm -fr ./rootfs.cpio.gz

pushd rootfs 
find . -print0 | cpio --null -ov --format=newc | gzip -9 > ../rootfs.cpio.gz
popd

/usr/bin/qemu-system-x86_64 \
        -m 128M \
        -cpu kvm64,+smep,+smap \
        -no-reboot \
        -kernel linux-5.4/arch/x86/boot/bzImage \
        -initrd $PWD/rootfs.cpio.gz \
        -fsdev local,security_model=passthrough,id=fsdev0,path=$HOME \
        -device virtio-9p-pci,id=fs0,fsdev=fsdev0,mount_tag=hostshare \
        -nographic \
        -monitor none \
        -s \
        -append "console=ttyS0 kaslr nopti smep smap panic=1"


