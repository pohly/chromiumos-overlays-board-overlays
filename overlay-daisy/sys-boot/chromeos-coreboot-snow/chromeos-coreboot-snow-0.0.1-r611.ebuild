# Copyright (c) 2013 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4
CROS_WORKON_COMMIT="e2f69a33e74dea01cbd4188673c14c4420819332"
CROS_WORKON_TREE="5b2203c23dc2ba609b9bdea7d6e3ab46080eae6e"
CROS_WORKON_PROJECT="chromiumos/third_party/coreboot"
CROS_WORKON_LOCALNAME="coreboot"

inherit cros-board cros-workon cros-coreboot

KEYWORDS="arm"

DEPEND="sys-boot/exynos-pre-boot"

RDEPEND="!sys-boot/chromeos-coreboot"

src_prepare() {
	# src is installed by "exynos-pre-boot".
	local src="${SYSROOT}/firmware/u-boot.bl1.bin"
	# dest is required by Makefile.inc in coreboot source tree.
	local dest="3rdparty/cpu/samsung/exynos5250/bl1.bin"

	mkdir -p "$(dirname "${dest}")"
	cp -pf "${src}" "${dest}" || die
}
