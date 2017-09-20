# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit toolchain-funcs

KEYWORDS="-* arm arm64"

DESCRIPTION="Camera HAL config files for gru"

LICENSE="Google-TOS"
SLOT="0"

S="${WORKDIR}"

src_install() {
	insinto /etc/camera
	doins "${FILESDIR}"/camera3_profiles.xml
	doins "${FILESDIR}"/gcss/*.xml

	insinto /etc/camera/rkisp1
	doins "${FILESDIR}"/IQ/*.xml

	insinto /usr/$(get_libdir)
	#TODO upload to mirror when it's stable.
	dolib.so "${FILESDIR}"/rk-3a-libs-bin/*.so*
}
