# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Topology binary files used to support/configure LPE Audio"

LICENSE="LICENCE.IntcSST2"
SLOT="0"
KEYWORDS="*"

S=${WORKDIR}

src_compile() {
	alsatplg -c "${FILESDIR}"/kbl/eve/kbl_i2s_chrome.conf -o dfw_sst.bin || die
}

src_install() {
	insinto /lib/firmware
	doins "${WORKDIR}"/dfw_sst.bin
}
