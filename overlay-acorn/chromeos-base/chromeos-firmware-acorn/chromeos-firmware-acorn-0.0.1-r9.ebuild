# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="4"
CROS_WORKON_COMMIT="4773273dec5ea6ff8151459a6b63b51dc4bc164d"
CROS_WORKON_TREE="2478df72531ff26f12dcb1519eebecdecec8acb5"
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
