# Tatl-arc

## Overview
Tatl-arc is the `x86_64` overlay for ARCVM; see the `tatl` and `project-termina`
overlays for details. This board is almost identical to `tatl` with the one
difference that the guest kernel config points to x86_64_arcvm_defconfig rather
than chromiumos-container-vm-x86_64_defconfig.

This board is only used to generate the guest kernel prebuilts, which are then
manually checked in to the Android tree.
