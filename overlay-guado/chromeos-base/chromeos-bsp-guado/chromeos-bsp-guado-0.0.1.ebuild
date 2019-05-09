# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit appid

DESCRIPTION="Ebuild which pulls in any necessary ebuilds as dependencies
or portage actions."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE="guado-cfm guado-kernelnext"
S="${WORKDIR}"

# Add dependencies on other ebuilds from within this board overlay
RDEPEND="
	chromeos-base/chromeos-bsp-baseboard-jecht
	chromeos-base/jabra-vold
	media-libs/go2001-fw
	media-libs/go2001-rules
"
DEPEND="${RDEPEND}"

src_install() {
	if use guado-cfm; then
		doappid "{5A5EE14C-32AC-D8D9-ACEA-C6A74DE79B63}" "CHROMEBOX"
	elif use guado-kernelnext; then
		doappid "{E88B19B8-72A2-11E9-B81D-D3F361E21ABF}" "CHROMEBOX"
	else
		doappid "{8AA6D9AC-6EBC-4288-A615-171F56F66B4E}" "CHROMEBOX"
	fi

	# Install Bluetooth ID override.
	insinto "/etc/bluetooth"
	doins "${FILESDIR}/main.conf"
}
