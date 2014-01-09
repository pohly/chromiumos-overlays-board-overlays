# Copyright (c) 2013 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4
CROS_WORKON_COMMIT=("ac6c24304436b0526c979d56acbb7ee6526b594e" "20344c07bbb2cf3f9429043128ec70136624c1f1")
CROS_WORKON_TREE=("ae49abe57564aeaa148c0acb7f623cf30a965b56" "095f1628d3138766c5659f8d35dbfd723881b8a9")
CROS_WORKON_PROJECT=("chromiumos/third_party/coreboot" "chromiumos/platform/vboot_reference")
CROS_WORKON_LOCALNAME=("coreboot" "../platform/vboot_reference")
CROS_WORKON_DESTDIR=("${S}" "${S}/vboot_reference")

COREBOOT_BOARD="nyan"
COREBOOT_BOARD_ROOT="google/nyan"
COREBOOT_BUILD_ROOT="builds/nyan"

inherit cros-board cros-workon cros-coreboot

KEYWORDS="arm"
IUSE="fwserial"

DEPEND="dev-embedded/cbootimage"

RDEPEND="chromeos-base/vboot_reference"

src_prepare() {
	if use fwserial; then
		elog "   - enabling firmware serial console"
		echo "CONFIG_CONSOLE_SERIAL=y" >> .config
	fi
}
