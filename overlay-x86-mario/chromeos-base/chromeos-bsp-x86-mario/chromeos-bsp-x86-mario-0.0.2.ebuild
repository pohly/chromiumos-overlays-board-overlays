# Copyright (c) 2013 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="4"

inherit appid cros-audio-configs toolchain-funcs udev

DESCRIPTION="Board-specific packages for x86-mario"
HOMEPAGE="http://src.chromium.org"
SRC_URI=""

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE=""

DEPEND="!chromeos-base/light-sensor
	!chromeos-base/chromeos-bsp-mario"
RDEPEND="${DEPEND}
	sys-apps/iotools"

S="${WORKDIR}"

src_install() {
	doappid "{87efface-864d-49a5-9bb3-4b050a7c227a}" "CHROMEBOOK"

	# Install Bluetooth ID override.
	insinto "/etc/bluetooth"
	doins "${FILESDIR}/main.conf"

	# Install platform-specific ambient light sensor configuration.
	udev_dorules "${FILESDIR}/99-light-sensor.rules"
	exeinto $(udev_get_udevdir)
	doexe "${FILESDIR}/light-sensor-set-multiplier.sh"

	# Install audio configs.
	local audio_config_dir="${FILESDIR}/audio-config"
	install_audio_configs x86-mario "${audio_config_dir}"
}
