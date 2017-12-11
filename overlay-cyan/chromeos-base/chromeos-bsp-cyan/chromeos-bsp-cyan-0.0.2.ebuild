# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit appid udev

DESCRIPTION="Ebuild which pulls in any necessary ebuilds as dependencies
or portage actions."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE="cyan-cheets"
S="${WORKDIR}"

# Add dependencies on other ebuilds from within this board overlay
RDEPEND="
	chromeos-base/chromeos-bsp-baseboard-strago
"
DEPEND="${RDEPEND}"

src_install() {
	if use cyan-cheets; then
		doappid "{EB589AF1-65F1-8B8B-8BBB-80450CA30620}" "CHROMEBOOK"
	else
		doappid "{11130F0B-738A-C024-7A78-CF72D93B77AF}" "CHROMEBOOK"
	fi

	# Install platform specific config files for power_manager.
	insinto "/usr/share/power_manager/board_specific"
	doins "${FILESDIR}"/powerd_prefs/*

	# Install Bluetooth ID override.
	insinto "/etc/bluetooth"
	doins "${FILESDIR}/main.conf"

	# Add udev rule for iwlwifi workaround for Intel NIC
	# disappearing from PCI bus
	udev_dorules "${FILESDIR}/iwlwifi/60-iwlwifi.rules"
	exeinto "$(get_udevdir)"
	doexe "${FILESDIR}/iwlwifi/wifi-pci-rescan.sh"
}
