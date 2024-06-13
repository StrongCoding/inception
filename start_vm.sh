#!/bin/bash

# Install images
NIXOS_INSTALL_IMAGE='latest-nixos-minimal-x86_64-linux.iso'
NIXOS_INSTALL_MIRROR="https://channels.nixos.org/nixos-23.11/$NIXOS_INSTALL_IMAGE"
COREOS_INSTALL_IMAGE='fedora-coreos-39.20240407.3.0-live.x86_64.iso'
COREOS_INSTALL_MIRROR="https://builds.coreos.fedoraproject.org/prod/streams/stable/builds/39.20240407.3.0/x86_64/$COREOS_INSTALL_IMAGE"
DEBIAN_INSTALL_IMAGE='debian-12.5.0-amd64-netinst.iso'
DEBIAN_INSTALL_MIRROR="https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/$INSTALL_IMAGE"
ALPINE_INSTALL_IMAGE='alpine-standard-3.19.1-x86_64.iso'
ALPINE_INSTALL_MIRROR="https://dl-cdn.alpinelinux.org/alpine/v3.19/releases/x86_64/$INSTALL_IMAGE"
ARCHLINUX_INSTALL_IMAGE='archlinux-2024.04.01-x86_64.iso'
ARCHLINUX_INSTALL_MIRROR="https://geo.mirror.pkgbuild.com/iso/2024.04.01/$ARCHLINUX_INSTALL_IMAGE"

# Machine configuration
DISK_IMAGE='disk0.qcow2'
QEMU_ARGS=(
    # CPU
    -cpu host,kvm=on,kvmclock=on
    -smp 4
    -enable-kvm

    # Machine
    -M q35,accel=kvm
    -m 4G
    -rtc base=localtime

    # Disk
    -drive id=disk0,file="$DISK_IMAGE",if=none,media=disk,snapshot=off,cache=none,aio=io_uring,format=qcow2
    -device virtio-blk-pci,drive=disk0

    # Network
    -device virtio-net-pci,netdev=net0
)

# Change into script directory
SCRIPT_DIR=$(dirname "${BASH_SOURCE[@]}")
cd "$SCRIPT_DIR"

# Handle arguments
if [ -z "$1" ]; then
    echo 'usage: start_vm.sh {disk,install,serial,normal}' 1>&2
    exit 1
fi
case "$1" in
    'disk')
        if [ -f "$DISK_IMAGE" ]; then
            while true; do
                read -n1 -p 'A disk image already exists. Overwrite? [y/n] ' ANSWER
                echo
                case "$ANSWER" in
                    'y')
                        break
                        ;;
                    'n')
                        exit 0
                        ;;
                esac
                echo 'Invalid input, quitting.' 1>&2
                exit 1
            done
        fi
        exec qemu-img create -fqcow2 "$DISK_IMAGE" 64G
        ;;
    'install')
        if [ ! -f "$DISK_IMAGE" ]; then
            echo 'fatal: No disk image found, please generate one.' 1>&2
            exit 1
        fi
        if [ -z "$2" ]; then
            echo 'usage: start_vm.sh install {nixos,coreos,debian,alpine,archlinux}' 1>&2
            exit 1
        fi
        case "$2" in
            'nixos')
                INSTALL_IMAGE="$NIXOS_INSTALL_IMAGE"
                INSTALL_MIRROR="$NIXOS_INSTALL_MIRROR"
                ;;
            'coreos')
                INSTALL_IMAGE="$COREOS_INSTALL_IMAGE"
                INSTALL_MIRROR="$COREOS_INSTALL_MIRROR"
                ;;
            'debian')
                INSTALL_IMAGE="$DEBIAN_INSTALL_IMAGE"
                INSTALL_MIRROR="$DEBIAN_INSTALL_MIRROR"
                ;;
            'alpine')
                INSTALL_IMAGE="$ALPINE_INSTALL_IMAGE"
                INSTALL_MIRROR="$ALPINE_INSTALL_MIRROR"
                ;;
            'archlinux')
                INSTALL_IMAGE="$ARCHLINUX_INSTALL_IMAGE"
                INSTALL_MIRROR="$ARCHLINUX_INSTALL_MIRROR"
                ;;
            *)
                echo 'Unknown install image. Valid images are: nixos, coreos, debian, alpine, archlinux' 1>&2
                exit 1
                ;;
        esac
        if [ ! -f "$INSTALL_IMAGE" ]; then
            while true; do
                read -n1 -p 'No install image was found. Download? [y/n] ' ANSWER
                echo
                case "$ANSWER" in
                    'y')
                        break
                        ;;
                    'n')
                        exit 0
                        ;;
                esac
                echo 'Invalid input, quitting.' 1>&2
            done
            curl -L -o "$INSTALL_IMAGE" "$INSTALL_MIRROR" -# || exit 1
        fi
        QEMU_ARGS+=(
            # Boot from install image
            -drive id=cdrom0,file="$INSTALL_IMAGE",if=ide,media=cdrom,format=raw
            -boot d

            # Run with standard VGA graphics
            -display gtk,zoom-to-fit=on
            -vga std

            # Access to internet, SSH forwarding to host port 2222
            -netdev user,id=net0,hostfwd=tcp::2222-:22
        )
        ;;
    'vga')
        if [ ! -f "$DISK_IMAGE" ]; then
            echo 'fatal: No disk image found, please generate one and install an OS.' 1>&2
            exit 1
        fi
        QEMU_ARGS+=(
            # Boot from disk
            -boot c

            # Run with standard VGA graphics
            -display gtk,zoom-to-fit=on
            -vga std

            # Access to internet, SSH forwarding to host port 2222
            -netdev user,id=net0,hostfwd=tcp::2222-:22
        )
        ;;
    'serial')
        if [ ! -f "$DISK_IMAGE" ]; then
            echo 'fatal: No disk image found, please generate one and install an OS.' 1>&2
            exit 1
        fi
        QEMU_ARGS+=(
            # Boot from disk
            -boot c

            # Run without any graphics but a serial console
            -serial stdio
            -display none
            -vga none

            # Access to internet, SSH forwarding to host port 2222
            -netdev user,id=net0,hostfwd=tcp::2222-:22
        )
        ;;
    'normal')
        if [ ! -f "$DISK_IMAGE" ]; then
            echo 'fatal: No disk image found, please generate one and install an OS.' 1>&2
            exit 1
        fi
        QEMU_ARGS+=(
            # Boot from disk
            -boot c

            # Run detached without any graphics
            -daemonize
            -display none
            -vga none

            # Access to internet, SSH forwarding to host port 2222
            -netdev user,id=net0,hostfwd=tcp::2222-:22
        )
        ;;
    *)
        echo 'Unknown mode. Valid modes are: disk, install, vga, serial, normal' 1>&2
        exit 1
        ;;
esac

# Replace the current shell with QEMU
exec qemu-system-x86_64 "${QEMU_ARGS[@]}"
