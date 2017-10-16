# Copyright (c) 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4

CROS_WORKON_BLACKLIST="1"
CROS_WORKON_INCREMENTAL_BUILD="0"

inherit cros-workon cros-kernel2 eutils

# TODO(jrbarnette):  Really, we want to eliminate this ebuild
# altogether, and rely on the standard Chromium OS kernel ebuild.
# http://crbug.com/302022

DESCRIPTION="Chrome OS Kernel-beaglebone"
HOMEPAGE="http://src.chromium.org"
GIT_SHA1="19b7b0251f7b6b3ac3f75ab4e43d84425ee230ee"
#SRC_URI="https://github.com/beagleboard/linux/archive/${GIT_SHA1}.tar.gz -> ${P}-${GIT_SHA1}.tar.gz"
# We recompress the gzip tarball to save ~44MiB.
# zcat xxx.tar.gz | pxz > xxx.tar.xz
SRC_URI="gs://chromeos-localmirror/distfiles/${P}-${GIT_SHA1}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* arm"

DEPEND="!sys-kernel/chromeos-kernel-next
		!sys-kernel/chromeos-kernel
		!sys-kernel/kernel-beaglebone
"
RDEPEND="${DEPEND}"

CHROMEOS_KERNEL_CONFIG="${FILESDIR}/config-${PV}"

S="${WORKDIR}/linux-${GIT_SHA1}"

src_unpack() {
	default
}

src_prepare() {
	cros-kernel2_src_prepare
	epatch "${FILESDIR}"/*.patch
}
