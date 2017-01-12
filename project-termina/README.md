# Termina

## Overview
The `project-termina` encompasses the majority of functionality for Termina.
Architecture-dependent leaf overlays should inherit from this overlay.
Currently, these are `tatl` (`x86_64`) and `tael` (`arm64`).

## Packages

### `chromeos-base/chromeos-bsp-termina`
Installs upstart .conf files to bring up the system to be able to start
a container.

### `chromeos-base/termina-auth-config`
Sets up PAM to allow root/chronos passwordless login. By default this is only
installed by `target-termina-os-dev`.

### `virtual/target-os*`
These override the normal Chromium OS targets to either no-op (e.g. the factory
shim) or depend on the corresponding `termina` equivalent.

### `virtual/target-termina-os*`
The `termina` target ebuilds should depend on packages for the appropriate
target. Release images will work with just `target-termina-os`, but
developers will likely want to include `target-termina-os-dev` as well to
enable serial console support and allow login.

## Building
`build_image` is not well suited for putting together a minimal rootfs image,
so for now we are piggybacking on the `package_to_container` script to put
together a squashfs rootfs image. TODO: better build script

Example:
```sh
export BOARD=tatl
./setup_board --board=${BOARD}
./build_packages --board=${BOARD} --nowithautotest
./package_to_container --board=${BOARD} --package target-termina-os --argv dontcare --extra target-termina-os-dev --name ${BOARD}-image
```

## Running
Copy the kernel and squashfs image to the DUT. The upstart `container` job will
attempt to execute a container that's provided over a 9p share. This is still
WIP.
```sh
export CONTAINER=<path to container>
lkvm run -d ${BOARD}-image.sqsh --9p ${CONTAINER},container_rootfs -k ${BOARD}-kernel
```
