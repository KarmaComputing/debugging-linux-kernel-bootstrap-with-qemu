#!/bin/bash
#
# Prior reading
# https://www.qemu.org/docs/master/system/introduction.html

set -x

echo Get kernel
wget --no-clobber https://boot.karmacomputing.co.uk/iso/alpine-netboot/boot/vmlinuz-lts

echo Get initramfs
wget --no-clobber https://boot.karmacomputing.co.uk/iso/alpine-netboot/boot/initramfs-lts

# See https://www.qemu.org/docs/master/system/introduction.html#running
echo Starting qemu
  # -cpu max: Enables all features supported by the accelerator in the current host
  # -serial mon:stdio: multiplex the QEMU Monitor with the serial port output
  # -display none: There is no graphical device, disable display & work entirely in the terminal
qemu_args=(
  -enable-kvm # utilize hardware virtualization of processors
  -cpu max  # Enables all features supported by the accelerator in the current host
  -smp 4 
  -m 4096 
  -kernel vmlinuz-lts 
  -initrd initramfs-lts 
  -serial mon:stdio # multiplex the QEMU Monitor with the serial port output

  # Since we're using -serial, ask linux to direct kernel log to the serial
  # so we can see it, withou this -append, we won't see the kernel boot log
  -append "console=ttyS0"
  # As there is no default graphical device we disable the display
  # as we can work entirely in the terminal.
  -display none
)
# Start qemu with the above args
qemu-system-x86_64 "${qemu_args[@]}"
