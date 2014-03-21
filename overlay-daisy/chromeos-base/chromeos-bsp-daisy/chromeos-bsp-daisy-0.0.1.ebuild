# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=2

inherit toolchain-funcs

DESCRIPTION="Daisy public bsp (meta package to pull in driver/tool dependencies)"

LICENSE="BSD"
SLOT="0"
KEYWORDS="arm"
IUSE="-spring -snow -samsung_serial"

DEPEND=""
RDEPEND="
	!<chromeos-base/chromeos-bsp-daisy-private-0.0.1-r11
	snow? ( chromeos-base/chromeos-init )
	samsung_serial? ( chromeos-base/serial-tty )
	chromeos-base/default-zram-size
	media-libs/media-rules
	media-libs/mfc-fw
	sys-apps/daisydog
	sys-boot/exynos-pre-boot
	x11-drivers/mali-rules
	x11-drivers/xf86-video-armsoc
"

src_install() {
	# Install platform specific config file for power_manager
	insinto "/usr/share/power_manager/board_specific"
	doins "${FILESDIR}/battery_poll_short_interval_ms" || die
	doins "${FILESDIR}/low_battery_shutdown_percent" || die
	doins "${FILESDIR}/low_battery_shutdown_time_s" || die
	doins "${FILESDIR}/wakeup_input_device_names" || die

	# Install platform specific usb device list for laptop mode tools
	insinto "/etc/laptop-mode/conf.d/board-specific"
	doins "${FILESDIR}/usb-autosuspend.conf" || die "installation failed ($?)"
	doins "${FILESDIR}/cpufreq.conf" || die "installation failed ($?)"
	doins "${FILESDIR}/runtime-pm.conf" || die "installation failed ($?)"

	if use spring || use snow || use spring; then
		# Install platform specific config file for thermal monitoring
		dosbin "${FILESDIR}/thermal.sh" || die "installation failed ($?)"
		insinto "/etc/init/"
		doins "${FILESDIR}/thermal.conf" || die "installation failed ($?)"
		insinto "/lib/udev/rules.d"
		doins "${FILESDIR}/50-rtc.rules" || die "installation failed ($?)"
	fi
}
