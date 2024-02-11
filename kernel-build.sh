#! /usr/bin/bash

#The specific kernel version should go here 
KERNEL_VERSION="5.0"


dependencies(){
        printf "[+] Dependenciez Check...\n"
        command -v /usr/bin/wget > /dev/null || { printf "[-] $(date): wget missing!\n"; exit 1; }
        command -v /usr/bin/tar > /dev/null  || { printf "[-] $(date): tar command missing!\n"; exit 1; }

        sudo apt -q update && sudo apt -q install -y bc bison flex libelf-dev cpio build-essential libssl-dev qemu-system-x86
}


init(){
        printf "[+] Downloading Kernel...\n"

        #The following URI will differ based on the chosen Kernel Version that is described above ^^
        wget -q -c https://mirrors.edge.kernel.org/pub/linux/kernel/v5.x/linux-$KERNEL_VERSION.tar.gz
        [ -e linux-$KERNEL_VERSION.tar.gz ] && tar -xvf linux-$KERNEL_VERSION.tar.gz

        printf "[+] Building Kernel..\n"

        make -C linux-$KERNEL_VERSION defconfig

        echo "CONFIG_NET_9P=y" >> linux-$KERNEL_VERSION/.config
        echo "CONFIG_NET_9P_DEBUG=n" >> linux-$KERNEL_VERSION/.config
        echo "CONFIG_9P_FS=y" >> linux-$KERNEL_VERSION/.config
        echo "CONFIG_9P_FS_POSIX_ACL=y" >> linux-$KERNEL_VERSION/.config
        echo "CONFIG_9P_FS_SECURITY=y" >> linux-$KERNEL_VERSION/.config
        echo "CONFIG_NET_9P_VIRTIO=y" >> linux-$KERNEL_VERSION/.config
        echo "CONFIG_VIRTIO_PCI=y" >> linux-$KERNEL_VERSION/.config
        echo "CONFIG_VIRTIO_BLK=y" >> linux-$KERNEL_VERSION/.config
        echo "CONFIG_VIRTIO_BLK_SCSI=y" >> linux-$KERNEL_VERSION/.config
        echo "CONFIG_VIRTIO_NET=y" >> linux-$KERNEL_VERSION/.config
        echo "CONFIG_VIRTIO_CONSOLE=y" >> linux-$KERNEL_VERSION/.config
        echo "CONFIG_HW_RANDOM_VIRTIO=y" >> linux-$KERNEL_VERSION/.config
        echo "CONFIG_DRM_VIRTIO_GPU=y" >> linux-$KERNEL_VERSION/.config
        echo "CONFIG_VIRTIO_PCI_LEGACY=y" >> linux-$KERNEL_VERSION/.config
        echo "CONFIG_VIRTIO_BALLOON=y" >> linux-$KERNEL_VERSION/.config
        echo "CONFIG_VIRTIO_INPUT=y" >> linux-$KERNEL_VERSION/.config
        echo "CONFIG_CRYPTO_DEV_VIRTIO=y" >> linux-$KERNEL_VERSION/.config
        echo "CONFIG_BALLOON_COMPACTION=y" >> linux-$KERNEL_VERSION/.config
        echo "CONFIG_PCI=y" >> linux-$KERNEL_VERSION/.config
        echo "CONFIG_PCI_HOST_GENERIC=y" >> linux-$KERNEL_VERSION/.config
        echo "CONFIG_GDB_SCRIPTS=y" >> linux-$KERNEL_VERSION/.config
        echo "CONFIG_DEBUG_INFO=y" >> linux-$KERNEL_VERSION/.config
        echo "CONFIG_DEBUG_INFO_REDUCED=n" >> linux-$KERNEL_VERSION/.config
        echo "CONFIG_DEBUG_INFO_SPLIT=n" >> linux-$KERNEL_VERSION/.config
        echo "CONFIG_DEBUG_FS=y" >> linux-$KERNEL_VERSION/.config
        echo "CONFIG_DEBUG_INFO_DWARF4=y" >> linux-$KERNEL_VERSION/.config
        echo "CONFIG_DEBUG_INFO_BTF=y" >> linux-$KERNEL_VERSION/.config
        echo "CONFIG_FRAME_POINTER=y" >> linux-$KERNEL_VERSION/.config


        sed -i 'N;s/WARN("missing symbol table");\n\t\treturn -1;/\n\t\treturn 0;\n\t\t\/\/ A missing symbol table is actually possible if its an empty .o file.  This can happen for thunk_64.o./g' linux-$KERNEL_VERSION/tools/objtool/elf.c

        sed -i 's/unsigned long __force_order/\/\/ unsigned long __force_order/g' linux-$KERNEL_VERSION/arch/x86/boot/compressed/pgtable_64.c

        make -C linux-$KERNEL_VERSION -j16 bzImage
}


dependencies
init
