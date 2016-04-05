# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit appid cros-audio-configs

DESCRIPTION="Ebuild which pulls in any necessary ebuilds as dependencies
or portage actions."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE=""
S="${WORKDIR}"

# Add dependencies on other ebuilds from within this board overlay
RDEPEND="
	chromeos-base/chromeos-bsp-baseboard-strago
	chromeos-base/ec-utils
	sys-kernel/linux-firmware
	chromeos-base/rmi4utils
"
DEPEND="${RDEPEND}"

src_install() {
	doappid "{6C192A59-6B44-490F-A824-3EF13C031E47}" "CHROMEBOOK"

	# Install audio configs.
	local audio_config_dir="${FILESDIR}/audio-config"
	install_audio_configs umaro "${audio_config_dir}"

	# Install Bluetooth ID override.
	insinto "/etc/bluetooth"
	doins "${FILESDIR}/main.conf"
}
