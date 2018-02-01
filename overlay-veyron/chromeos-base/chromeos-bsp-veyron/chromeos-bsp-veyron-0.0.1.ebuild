# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit udev

DESCRIPTION="Veyron bsp (meta package to pull in driver/tool dependencies)"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="-* arm"
IUSE="ac_only bluetooth cros_ec +veyron-brcmfmac-nvram"

# Add dependencies on other ebuilds from within this board overlay
DEPEND="
	!media-libs/media-rules
	"
RDEPEND="${DEPEND}
	x11-drivers/mali-rules
	bluetooth? ( net-wireless/broadcom )
"

S=${WORKDIR}

src_install() {
	# Install platform specific config files for power_manager.
	insinto "/usr/share/power_manager/board_specific"
	doins "${FILESDIR}"/powerd_prefs/*

	# Override default CPU clock speed governor
	insinto "/etc"
	doins "${FILESDIR}/cpufreq.conf"

	# Install platform specific files for bcm4354 bluetooth.
	if use bluetooth ; then
		insinto "/etc/modprobe.d"
		doins "${FILESDIR}"/blacklist-btsdio.conf

		# Install platform specific files to start Broadcom patchram
		udev_dorules "${FILESDIR}/99-veyron-brcm.rules"
	fi

	# Install platform specific files to enable persist on ehci-platform
	udev_dorules "${FILESDIR}/99-rk3288-ehci-persist.rules"
	# Install platform specific files to avoid wakeup system by gpio-charger
	udev_dorules "${FILESDIR}/99-rk3288-gpio-charger.rules"

	# Disable autosuspend for ac_only to make webcams work a bit
	# better on boxes
	use ac_only && udev_dorules "${FILESDIR}/99-rk3288-no-dwc2-autosuspend.rules"

	# Install platform specific NVRAM files for brcmfmac.
	if use veyron-brcmfmac-nvram ; then
		insinto "/lib/firmware/brcm"
		doins "${FILESDIR}/firmware/brcmfmac4354-sdio.txt"
	fi

	# Install platform specific triggers and udev rules for codecs.
	insinto "/etc/init"
	doins "${FILESDIR}/udev-trigger-codec.conf"
	udev_dorules "${FILESDIR}/50-media.rules"
}
