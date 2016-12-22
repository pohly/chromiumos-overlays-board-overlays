# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4
CROS_WORKON_COMMIT="3a6653fd33b3d8b56fdbbefa974537c8e18c01b9"
CROS_WORKON_TREE="edc06131fbc208e8e676bdd1c2ac344ffef6aebd"
CROS_WORKON_PROJECT="chromiumos/third_party/kernel"
CROS_WORKON_LOCALNAME="kernel/v4.4"

CHROMEOS_KERNEL_CONFIG="${FILESDIR}/lakitu_kernel_config_4_4"

# This must be inherited *after* EGIT/CROS_WORKON variables defined
inherit cros-workon cros-kernel2

DESCRIPTION="Chromium OS Linux Kernel 4.4"
HOMEPAGE="https://www.chromium.org/chromium-os/chromiumos-design-docs/chromium-os-kernel"
KEYWORDS="*"
