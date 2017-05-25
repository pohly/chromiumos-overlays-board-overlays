# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="FPC libfp, binary only install"
SRC_URI="http://commondatastorage.googleapis.com/chromeos-localmirror/distfiles/libfp-gru-${PV}.tbz2"

LICENSE="Google-TOS"
SLOT="0"
KEYWORDS="-* arm64 arm"
RESTRICT="mirror"

S=${WORKDIR}

src_install() {
	exeinto /opt/fpc/lib
	doexe usr/lib/libfpsensor.so.0
	dosym libfpsensor.so.0 /opt/fpc/lib/libfpsensor.so
	insinto /opt/fpc/lib
	doins usr/lib/libfpalgorithm.a
}
