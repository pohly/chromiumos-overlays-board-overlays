# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit appid cros-audio-configs toolchain-funcs udev

DESCRIPTION="Ebuild which pulls in any necessary ebuilds as dependencies
or portage actions."

LICENSE="BSD"
SLOT="0"
KEYWORDS="-* amd64 x86"

DEPEND="!chromeos-base/light-sensor"
# modemmanager provides Y3300 support.
RDEPEND="${DEPEND}
	!<chromeos-base/chromeos-bsp-lumpy-private-0.0.6
	sys-apps/iotools
	virtual/modemmanager
"

S=${WORKDIR}

src_install() {
	doappid "{A854E62E-9CB3-4DBE-8BBE-88C48FD65787}" "CHROMEBOOK"

	# Install platform-specific ambient light sensor configuration.
	udev_dorules "${FILESDIR}/99-light-sensor.rules"
	exeinto $(udev_get_udevdir)
	doexe "${FILESDIR}/light-sensor-set-multiplier.sh"

	# Install platform specific config files for power_manager.
	insinto "/usr/share/power_manager/board_specific"

	local audio_config_dir="${FILESDIR}/audio-config"
	install_audio_configs lumpy "${audio_config_dir}"

	# Install Bluetooth ID override.
	insinto "/etc/bluetooth"
	doins "${FILESDIR}/main.conf"
}
