# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit appid

DESCRIPTION="Ebuild which pulls in any necessary ebuilds as dependencies
or portage actions."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="-* arm64 arm"
IUSE=""
S="${WORKDIR}"

# Add dependencies on other ebuilds from within this board overlay
DEPEND=""
RDEPEND="${DEPEND}
	media-libs/media-rules
"

src_install() {
	doappid "{8D0990C8-904D-45FD-ACEB-DCCAD82EC66E}" "CHROMEBOOK"

	# install ucm config files
	insinto /usr/share/alsa/ucm
	local ucm_config="${FILESDIR}/ucm-config"
	if [[ -d "${ucm_config}" ]] ; then
		doins -r "${ucm_config}"/*
	fi

	# Install platform specific config files for power_manager.
	insinto "/usr/share/power_manager/board_specific"
	doins "${FILESDIR}"/powerd_prefs/*
}
