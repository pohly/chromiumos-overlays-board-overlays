# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4
CROS_WORKON_COMMIT="2666fd48a9e19d930b40d4ac1de9b122453c7b96"
CROS_WORKON_TREE="29d08b95ed71acabf9268d10266d0754de574b86"
CROS_WORKON_PROJECT="chromiumos/third_party/kernel"
CROS_WORKON_LOCALNAME="kernel/v4.4"

CHROMEOS_KERNEL_CONFIG="${FILESDIR}/lakitu_kernel_config_4_4"

# This must be inherited *after* EGIT/CROS_WORKON variables defined
inherit cros-workon cros-kernel2

STRIP_MASK+=" /usr/src/${P}/build/vmlinux"

DESCRIPTION="Chromium OS Linux Kernel 4.4"
HOMEPAGE="https://www.chromium.org/chromium-os/chromiumos-design-docs/chromium-os-kernel"
KEYWORDS="*"
