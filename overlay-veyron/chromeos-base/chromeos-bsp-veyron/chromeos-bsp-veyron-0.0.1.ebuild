# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit udev

DESCRIPTION="Veyron bsp (meta package to pull in driver/tool dependencies)"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="-* arm"
IUSE="
	ac_only
	bluetooth
	cheets
	cros_ec
	kernel-3_14
	kernel-4_19
	+veyron-brcmfmac-nvram
"

# Must specify one of 3.14 or 4.19, but not both
REQUIRED_USE="^^ ( kernel-3_14 kernel-4_19 )"

# Add dependencies on other ebuilds from within this board overlay
DEPEND="
	!media-libs/media-rules
	"
RDEPEND="${DEPEND}
	x11-drivers/mali-rules
	bluetooth? ( net-wireless/broadcom )
	net-wireless/marvell_sd8787
"

S=${WORKDIR}

src_install() {
	# Install platform specific config files for power_manager.
	insinto "/usr/share/power_manager/board_specific"
	doins "${FILESDIR}"/powerd_prefs/*

	# Override default CPU clock speed governor
	if use kernel-3_14; then
		insinto "/etc"
		doins "${FILESDIR}/cpufreq-314/cpufreq.conf"
	else
		insinto "/etc"
		doins "${FILESDIR}/cpufreq-419/cpufreq.conf"
		insinto "/etc/init"
		doins "${FILESDIR}/cpufreq-419/platform-cpusets.conf"

		if use cheets; then
			insinto "/opt/google/containers/android/vendor/etc/init/"
			doins "${FILESDIR}/cpufreq-419/init.cpusets.rc"
		fi
	fi

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

	# On non-ac_only at least make hubs behave a little better
	use ac_only || udev_dorules "${FILESDIR}/99-rk3288-delay-hub-autosuspend.rules"

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
