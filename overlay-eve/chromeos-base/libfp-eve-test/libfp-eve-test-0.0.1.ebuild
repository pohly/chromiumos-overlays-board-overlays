# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="FPC test-only related binaries"
SRC_URI="http://commondatastorage.googleapis.com/chromeos-localmirror/distfiles/libfp-eve-test-${PV}.tbz2"

LICENSE="Google-TOS"
SLOT="0"
KEYWORDS="-* amd64 x86"
RESTRICT="mirror"

RDEPEND="dev-cpp/gtest"

S=${WORKDIR}

src_install() {
	# These are prebuilt binaries
	dobin Debug/usr/bin/int_test Debug/usr/bin/libfp_test Debug/usr/bin/stt Debug/usr/sbin/fptest
}
