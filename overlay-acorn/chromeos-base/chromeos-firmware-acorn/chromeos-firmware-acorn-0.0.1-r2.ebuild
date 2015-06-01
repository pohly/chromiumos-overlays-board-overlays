# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="4"
CROS_WORKON_COMMIT="16aaabeb9260596973d879dc17c6a6176c84497f"
CROS_WORKON_TREE="e96d4af9f0cc0956ad4ef2fa967ed204302a91be"
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
