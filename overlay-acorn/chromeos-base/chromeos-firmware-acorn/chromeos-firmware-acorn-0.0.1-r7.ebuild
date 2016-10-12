# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="4"
CROS_WORKON_COMMIT="8b066a543f472d9b10d6b0d2184009f272826c11"
CROS_WORKON_TREE="dc9c83c5f2acc181807ca0047d9f223acc906ddd"
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
