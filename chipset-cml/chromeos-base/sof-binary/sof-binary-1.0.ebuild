# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2.

EAPI=5

DESCRIPTION="Comet Lake SOF firmware binary"
SRC_URI="gs://chromeos-localmirror/distfiles/${P}-cml.tar.xz"

LICENSE="SOF"
SLOT="0"
KEYWORDS="*"

S=${WORKDIR}/${P}-cml

src_install() {
	insinto /lib/firmware/intel/sof
	doins sof-cnl.ri
	dodoc README
}
