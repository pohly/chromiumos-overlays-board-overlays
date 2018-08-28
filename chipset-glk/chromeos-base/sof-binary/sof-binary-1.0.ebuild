# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2.

EAPI=5

DESCRIPTION="Gemini Lake SOF firmware binary"
SRC_URI="gs://chromeos-localmirror/distfiles/${P}-glk.tar.bz2"

LICENSE="SOF"
SLOT="0"
KEYWORDS="*"

S=${WORKDIR}/${P}-glk

src_install() {
	insinto /lib/firmware/intel
	doins sof-glk.ri
	dodoc README
}
