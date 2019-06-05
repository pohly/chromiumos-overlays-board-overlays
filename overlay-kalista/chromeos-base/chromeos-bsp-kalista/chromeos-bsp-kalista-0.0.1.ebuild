# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=5

inherit appid cros-unibuild udev

DESCRIPTION="Ebuild which pulls in any necessary ebuilds as dependencies
or portage actions."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE="kalista-cfm"
S="${WORKDIR}"

# Add dependencies on other ebuilds from within this board overlay
RDEPEND="
	chromeos-base/chromeos-config
	chromeos-base/jabra-vold
"
DEPEND="${RDEPEND}"

src_install() {
	if use kalista-cfm; then
		doappid "{AE78E4C6-CF2D-411C-AB9A-339904DE5E2B}" "CHROMEBASE"
	else
		doappid "{073ABAF9-40D3-4065-85F3-74B1FA49675D}" "CHROMEBASE"
	fi

	unibuild_install_audio_files

	insinto "/etc/bluetooth"
	doins "${FILESDIR}/common/bluetooth/main.conf"

	# Install udev rules
	udev_dorules "${FILESDIR}"/udev/*.rules
}
