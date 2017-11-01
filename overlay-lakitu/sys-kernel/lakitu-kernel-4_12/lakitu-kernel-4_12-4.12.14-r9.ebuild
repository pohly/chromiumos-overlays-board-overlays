# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT="342e9bba9e019fd1c7266cb3a1e97a6374e45bde"
CROS_WORKON_TREE="ebd36ea7ecc0ab24bb1d3d780e508d96d66fd2fd"
CROS_WORKON_PROJECT="chromiumos/third_party/kernel"
CROS_WORKON_LOCALNAME="kernel/v4.12"

CHROMEOS_KERNEL_CONFIG="${FILESDIR}/base.config"

# This must be inherited *after* EGIT/CROS_WORKON variables defined
inherit cros-workon cros-kernel2 osreleased

STRIP_MASK+=" /usr/src/${P}/build/vmlinux"

DESCRIPTION="Chromium OS Linux Kernel 4.12"
HOMEPAGE="https://www.chromium.org/chromium-os/chromiumos-design-docs/chromium-os-kernel"
KEYWORDS="*"

src_install() {
	cros-kernel2_src_install

	# VCSID variable is unconditionally set by the cros-workon eclass, and
	# is in the form of "<ebuild_revision>-<sha1>".
	do_osrelease_field "KERNEL_COMMIT_ID" "${VCSID##*-}"
}
