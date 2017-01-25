# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4

DESCRIPTION="FPC libfp, binary only install"
SRC_URI="http://commondatastorage.googleapis.com/chromeos-localmirror/distfiles/libfp-eve-${PV}.tbz2"

LICENSE="Google-TOS"
SLOT="0"
KEYWORDS="-* amd64 x86"
RESTRICT="mirror"

DEPEND=""

RDEPEND="test? ( dev-cpp/gtest )"

S=${WORKDIR}

src_install() {
	exeinto /usr/local/bin
	doexe usr/bin/int_test usr/bin/libfp_test

	exeinto /opt/fpc/lib
	doexe usr/lib/libfp.so.0
	dosym libfp.so.0 /opt/fpc/lib/libfp.so
}
