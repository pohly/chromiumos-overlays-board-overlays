# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit appid cros-audio-configs udev


DESCRIPTION="Ebuild which pulls in any necessary ebuilds as dependencies
or portage actions."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="-* arm64 arm"
S="${WORKDIR}"

# Add dependencies on other ebuilds from within this board overlay
DEPEND=""
RDEPEND="${DEPEND}
	chromeos-base/chromeos-accelerometer-init
	media-libs/media-rules
	sys-apps/ethtool
"

src_install() {
	doappid "{AAE972E1-A913-C860-B7AB-BF7F267F199B}" "CHROMEBOOK"

	# Install audio config files.
	local audio_config_dir="${FILESDIR}/audio-config"
	install_audio_configs hana "${audio_config_dir}"

	# Install platform specific config files for power_manager.
	insinto "/usr/share/power_manager/board_specific"
	doins "${FILESDIR}"/powerd_prefs/*

	# Install rules to enable WoWLAN on startup.
	udev_dorules "${FILESDIR}/99-mwifiex-wowlan.rules"

	# Install rules to detect when DRM HDMI driver is loaded
	udev_dorules "${FILESDIR}/99-mtk_drm_hdmi_load.rules"

	# Install script called by 99-mtk_drm_hdmi_load.rules
	dosbin "${FILESDIR}"/hdcp_pass_key.sh

	# Install Bluetooth ID override.
	insinto "/etc/bluetooth"
	doins "${FILESDIR}/main.conf"
}
