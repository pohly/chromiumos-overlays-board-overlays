# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit appid udev
inherit appid cros-audio-configs


DESCRIPTION="Ebuild which pulls in any necessary ebuilds as dependencies
or portage actions."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="-* arm64 arm"
IUSE="cheets"
S="${WORKDIR}"

# Add dependencies on other ebuilds from within this board overlay
DEPEND=""
RDEPEND="${DEPEND}
	chromeos-base/chromeos-accelerometer-init
	media-libs/media-rules
	sys-apps/ethtool
	media-gfx/ply-image
	net-wireless/marvell_sd8787
"

src_install() {
	if use cheets; then
		doappid "{3DFF3394-F97E-4971-83C6-2C5C06A9953D}" "CHROMEBOOK"
	else
		doappid "{5BF597B2-ADE3-52C9-1DDA-95719C914AFF}" "CHROMEBOOK"
	fi

	# Install audio config files.
	local audio_config_dir="${FILESDIR}/audio-config"
	install_audio_configs elm "${audio_config_dir}"

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

	# Battery cut-off
	dosbin "${FILESDIR}/battery_cut_off.sh"
	dosbin "${FILESDIR}/board_factory_complete.sh"
	dosbin "${FILESDIR}/board_factory_wipe.sh"
	dosbin "${FILESDIR}/board_factory_reset.sh"
	dosbin "${FILESDIR}/board_charge_battery.sh"
	dosbin "${FILESDIR}/board_discharge_battery.sh"

	insinto "/usr/share/factory/images"
	doins "${FILESDIR}/remove_ac.png"
	doins "${FILESDIR}/call_shopfloor.png"
	doins "${FILESDIR}/cutting_off.png"
	doins "${FILESDIR}/cutoff_failed.png"
	doins "${FILESDIR}/charging.png"
	doins "${FILESDIR}/discharging.png"
	doins "${FILESDIR}/connect_ac.png"
	doins "${FILESDIR}/connect_ethernet.png"
	doins "${FILESDIR}/shopfloor_call_done.png"
}
