### Linux-Kernel-Build-Scripts

1. `kernel-build.sh` - This can used to download a Linux Kernel whose version is provided in the script. The script will also update the Kernel with a set of configurations *(the config file can be update with custom configurations that you might require)*. A final compilation is then made to build the final Kernel Image that will be at `linux-version/arch/x86/boot/bzImage`

2. `bzimage-to-vmlinux.sh` - This script can be used to convert the built `bzImage` to a `vmlinux` binary file to be used for debugging. The following is its usage.
```bash
./bzimage-to-vmlinux.sh > vmlinux
```
