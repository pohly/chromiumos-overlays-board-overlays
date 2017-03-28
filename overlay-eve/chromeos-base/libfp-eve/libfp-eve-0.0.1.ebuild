# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="FPC libfp, binary only install"
SRC_URI="http://commondatastorage.googleapis.com/chromeos-localmirror/distfiles/libfp-eve-${PV}.tbz2"

LICENSE="Google-TOS"
SLOT="0"
KEYWORDS="-* amd64 x86"
RESTRICT="mirror"

S=${WORKDIR}

src_install() {
	exeinto /opt/fpc/lib
	doexe Debug/usr/lib/libfp.so.0
	dosym libfp.so.0 /opt/fpc/lib/libfp.so
}
