# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit appid cros-audio-configs udev

DESCRIPTION="Pit bsp (meta package to pull in driver/tool deps)"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="-* arm"

DEPEND="!<chromeos-base/chromeos-bsp-pit-private-0.0.2"
RDEPEND="${DEPEND}
	chromeos-base/chromeos-touch-config-pit
	chromeos-base/default-zram-size
	chromeos-base/thermal
"

S=${WORKDIR}

src_install() {
	doappid "{24E2E4F7-F92C-6115-3E26-02C7EAA02946}" "CHROMEBOOK"

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
