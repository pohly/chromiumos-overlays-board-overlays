# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

KEYWORDS="-* arm arm64"

DESCRIPTION="Camera HAL config files for Scarlet"

LICENSE="Apache-2.0"
SLOT="0"

S="${WORKDIR}"

src_install() {
	insinto /etc/camera
	doins "${FILESDIR}"/camera3_profiles.xml
	doins "${FILESDIR}"/gcss/*.xml

	insinto /etc/camera/rkisp1
	doins "${FILESDIR}"/IQ/*.xml
}
