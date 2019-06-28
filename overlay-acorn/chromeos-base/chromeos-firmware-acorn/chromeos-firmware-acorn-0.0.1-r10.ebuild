# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="4"
CROS_WORKON_COMMIT="82b4358bb82a8be3eb2ee1723736229acb6e6c03"
CROS_WORKON_TREE="62259270c4b9816fbf24a9071e1550f3affefeee"
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
