# Copyright 2016 The Chromium OS Authors.
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit appid udev

DESCRIPTION="Mickey bsp (meta package to pull in driver/tool deps)"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="-* arm"
IUSE="bluetooth"

DEPEND=""
RDEPEND="
	media-libs/vpd-hdcpkey-install
"

S=${WORKDIR}

src_install() {
	doappid "{181B8BE1-07A0-4D54-87B7-0157A4322FF1}" "CHROMEBIT" # veyron-mickey

	# Install Bluetooth ID override.
	insinto "/etc/bluetooth"
	doins "${FILESDIR}/main.conf"
}
