# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit udev

DESCRIPTION="Peach bsp (meta package to pull in driver/tool dependencies)"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="-* arm"
IUSE=""

DEPEND=""
RDEPEND="
	!media-libs/media-rules
	net-wireless/marvell_sd8787
	x11-drivers/mali-rules
"

S="${WORKDIR}"

src_install() {
	# Install platform specific triggers and udev rules for codecs.
	insinto "/etc/init"
	doins "${FILESDIR}/udev-trigger-codec.conf"
	udev_dorules "${FILESDIR}/50-media.rules"
}
