# Copyright (c) 2013 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit appid

DESCRIPTION="Ebuild which pulls in any necessary ebuilds as dependencies
or portage actions."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE=""

# Add dependencies on other ebuilds from within this board overlay
RDEPEND="
	!<chromeos-base/chromeos-bsp-leon-private-0.0.2
"

DEPEND="${RDEPEND}"

S="${WORKDIR}"

src_install() {
	doappid "{D3844706-6B0E-78DF-752C-00DCDF11E04B}" "CHROMEBOOK"

	# Install platform specific config file for power_manager
	insinto "/usr/share/power_manager/board_specific"
	doins "${FILESDIR}"/powerd_prefs/*
}
