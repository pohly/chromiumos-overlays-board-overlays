# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit appid cros-audio-configs udev

DESCRIPTION="Pi bsp (meta package to pull in driver/tool deps)"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="-* arm"

DEPEND="!<chromeos-base/chromeos-bsp-pi-private-0.0.2"
RDEPEND="${DEPEND}
	chromeos-base/chromeos-touch-config-pi
	chromeos-base/thermal
"

S=${WORKDIR}

src_install() {
	doappid "{5615D466-EF74-FCD0-46EA-D7F60416B3CD}" "CHROMEBOOK" # peach-pi

	# Install platform-specific ambient light sensor configuration.
	udev_dorules "${FILESDIR}/99-light-sensor.rules"
	exeinto $(get_udevdir)
	doexe "${FILESDIR}/light-sensor-set-multiplier.sh"

	# Install platform specific config files for power_manager.
	insinto "/usr/share/power_manager/board_specific"
	doins "${FILESDIR}"/powerd_prefs/*

	# Override default CPU clock speed governor
	insinto "/etc"
	doins "${FILESDIR}/cpufreq.conf"

	# Install audio configs
	local audio_config_dir="${FILESDIR}/audio-config"
	install_audio_configs peach_pi "${audio_config_dir}"
}
