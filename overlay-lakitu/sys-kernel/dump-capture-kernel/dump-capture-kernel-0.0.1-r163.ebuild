# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT="e071366d54aef88ed5a633a6c736cbd6b66c120e"
CROS_WORKON_TREE="8c45fb49d65f65ebd5e5331f6e1cd3f3e0580855"
CROS_WORKON_PROJECT="chromiumos/third_party/kernel"
CROS_WORKON_LOCALNAME="kernel/v4.14"

CHROMEOS_KERNEL_CONFIG="${FILESDIR}/base.config"

# This must be inherited *after* EGIT/CROS_WORKON variables defined
inherit cros-workon cros-kernel2

STRIP_MASK+=" /usr/src/${P}/build/vmlinux"
STRIP_MASK+=" *.ko"

DESCRIPTION="A dump capture kernel for kdump functionality"
HOMEPAGE="https://www.chromium.org/chromium-os/chromiumos-design-docs/chromium-os-kernel"
KEYWORDS="*"


src_install() {
	dodir /boot/kdump
	kmake INSTALL_PATH="${D}/boot/kdump" INSTALL_MOD_PATH="${D}" \
		INSTALL_MOD_STRIP=1 install
	local version
	version=$(kmake -s --no-print-directory kernelrelease)
	ln -sf "vmlinuz-${version}" "${D}/boot/kdump/vmlinuz" || die

	# We also strips the symbol table /boot/kdump/System.map-* at:
	# overlay-lakitu/scripts/board_specific_setup.sh
}

# Change the following (commented out) number to the next prime number
# when you change base.config.  This workaround will force the
# ChromeOS CQ to uprev sys-kernel/dump-capture-kernel-4_14 ebuild and pick up the
# configuration changes.  In absence of this workaround the config changes
# would not be picked up unless there was a code change in kernel source tree.
#
# NOTE: There's nothing magic keeping this number prime but you just need to
# make _any_ change to this file.  ...so why not keep it prime?
#
# The coolest prime number is: 3
