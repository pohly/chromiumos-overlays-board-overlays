# Copyright (c) 2011 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="4"

inherit appid cros-audio-configs udev

DESCRIPTION="Board-specific packages for ZGB"
HOMEPAGE="http://src.chromium.org"
SRC_URI=""

LICENSE="BSD"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE=""

DEPEND="!chromeos-base/light-sensor"
# modemmanager provides Ericsson support.
RDEPEND="${DEPEND}
	chromeos-base/vpd
	sys-apps/iotools
	virtual/modemmanager
"

S=${WORKDIR}

src_install() {
	doappid "{23F5C60F-7655-4BF4-90FB-BFDE16408308}" "CHROMEBOOK"

	# Install Bluetooth ID override.
	insinto "/etc/bluetooth"
	doins "${FILESDIR}/main.conf"

	# Install platform-specific ambient light sensor configuration.
	udev_dorules "${FILESDIR}/99-light-sensor.rules"
	exeinto $(get_udevdir)
	doexe "${FILESDIR}/light-sensor-set-multiplier.sh"

	# Install audio configs.
	local audio_config_dir="${FILESDIR}/audio-config"
	install_audio_configs x86-zgb "${audio_config_dir}"
}
