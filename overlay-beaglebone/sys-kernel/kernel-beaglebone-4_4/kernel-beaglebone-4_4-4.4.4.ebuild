# Copyright (c) 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4

CROS_WORKON_REPO="git://github.com/beagleboard"
CROS_WORKON_PROJECT="linux"
CROS_WORKON_BLACKLIST="1"
CROS_WORKON_COMMIT="19b7b0251f7b6b3ac3f75ab4e43d84425ee230ee"

inherit cros-workon cros-kernel2 eutils

# TODO(jrbarnette):  Really, we want to eliminate this ebuild
# altogether, and rely on the standard Chromium OS kernel ebuild.
# http://crbug.com/302022

DESCRIPTION="Chrome OS Kernel-beaglebone"
HOMEPAGE="http://src.chromium.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* arm"

DEPEND="!sys-kernel/chromeos-kernel-next
		!sys-kernel/chromeos-kernel
		!sys-kernel/kernel-beaglebone
"
RDEPEND="${DEPEND}"

CHROMEOS_KERNEL_CONFIG="${FILESDIR}/config-${PV}"

src_prepare() {
	cros-kernel2_src_prepare
	epatch "${FILESDIR}"/*.patch
}
