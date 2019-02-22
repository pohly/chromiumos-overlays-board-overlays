# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="4"
CROS_WORKON_COMMIT="017391b6db0e006c3f40d3656591c6c695707a6d"
CROS_WORKON_TREE="f9fc6947587d392cae17f204731d20e98d0d064c"
CROS_WORKON_PROJECT="chromiumos/third_party/marvell"

inherit eutils cros-workon

DESCRIPTION="Firmware for Marvell Brillo overlay - acorn"
HOMEPAGE="http://src.chromium.org"
LICENSE="Marvell-sd8787"

SLOT="0"
KEYWORDS="*"

RESTRICT="binchecks strip test"

DEPEND=""
RDEPEND=""

CROS_WORKON_LOCALNAME="third_party/marvell"

src_install() {
	insinto /lib/firmware/mrvl
	doins pcie8*.bin
}
