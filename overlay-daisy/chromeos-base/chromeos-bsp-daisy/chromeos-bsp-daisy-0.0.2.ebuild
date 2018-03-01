# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit appid udev

DESCRIPTION="Daisy public bsp (meta package to pull in driver/tool dependencies)"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="-* arm"
IUSE="-spring -snow -skate"

DEPEND="
	!<chromeos-base/chromeos-bsp-spring-private-0.0.1-r16
	!<chromeos-base/chromeos-bsp-daisy-private-0.0.1-r27
	!chromeos-base/light-sensor
	!media-libs/media-rules
"
RDEPEND="${DEPEND}
	skate? ( chromeos-base/chromeos-init chromeos-base/thermal )
	snow? ( chromeos-base/chromeos-init chromeos-base/thermal )
	spring? ( chromeos-base/chromeos-init chromeos-base/thermal )
	chromeos-base/default-zram-size
	media-libs/mfc-fw
	sys-boot/exynos-pre-boot
	x11-drivers/mali-rules
"

S=${WORKDIR}

src_install() {
	# Install the proper appid depending on the board being built.
	# This would normally be done with board_use_$BOARD USE flags.
	if use spring; then
		# Have to check spring first since it's a superset of snow.
		doappid "{ADA16F7B-283C-4907-AE27-ABBF5CA4F7F1}" "CHROMEBOOK"
	elif use snow; then
		doappid "{D851316B-7E57-4805-A7CE-01829AC1443E}" "CHROMEBOOK"
	fi

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

	if use snow || use spring; then
		udev_dorules "${FILESDIR}/50-rtc.rules"
	fi

	# Install platform specific upstart jobs
	insinto /etc/init
	doins "${FILESDIR}/send-asv-metrics.conf"

	# Install platform specific triggers and udev rules for codecs.
	doins "${FILESDIR}/udev-trigger-codec.conf"
	udev_dorules "${FILESDIR}/50-media.rules"
}
