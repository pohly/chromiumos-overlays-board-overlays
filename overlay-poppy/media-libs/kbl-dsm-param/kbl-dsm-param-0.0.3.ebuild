# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="kbl tuning DSM Param"
SRC_URI="gs://chromeos-localmirror/distfiles/kbl-dsm-param-poppy-${PVR}.tbz2"

LICENSE="LICENCE.adsp_sst"		#FIXME: Need DSM license
SLOT="0"
KEYWORDS="-* x86 amd64"

S="${WORKDIR}"

src_install() {
	insinto /opt/google/dsm
	doins dsmparam.bin
}
