# Tael-arc

## Overview
Tael-arc is the `armv8` overlay for ARCVM; see the `tael` and `project-termina`
overlays for details. This board is almost identical to `tael` with the one
difference that the guest kernel config points to arm64_arcvm_defconfig rather
than chromiumos-container-vm-arm64_defconfig.

This board is only used to generate the guest kernel prebuilts, which are then
manually checked in to the Android tree.
