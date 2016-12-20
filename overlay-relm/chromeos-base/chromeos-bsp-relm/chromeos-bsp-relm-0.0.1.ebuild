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
        media-gfx/ply-image
"
DEPEND="${RDEPEND}"

src_install() {
	doappid "{3FC66B4B-1B63-94FA-BD6F-DB856B496918}" "CHROMEBOOK"

	# Install platform specific config files for power_manager.
	insinto "/usr/share/power_manager/board_specific"
	doins "${FILESDIR}"/powerd_prefs/*

	# Wiping scripts.
	dosbin "${FILESDIR}"/sbin/*.sh

	# Install audio configs.
	local audio_config_dir="${FILESDIR}/audio-config"
	install_audio_configs relm "${audio_config_dir}"

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
