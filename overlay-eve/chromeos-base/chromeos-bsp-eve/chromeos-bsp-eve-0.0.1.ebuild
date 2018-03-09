# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit cros-audio-configs
inherit appid
inherit udev

DESCRIPTION="Ebuild which pulls in any necessary ebuilds as dependencies
or portage actions."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE="eve-userdebug eve-kvm eve-arcnext"
S="${WORKDIR}"

# Add dependencies on other ebuilds from within this board overlay
RDEPEND="
	chromeos-base/genius-app-data-eve
	chromeos-base/u2fd"

DEPEND="${RDEPEND}"

src_install() {
	if use eve-userdebug; then
		doappid "{20C53672-DEE7-4824-A131-D9547AB409ED}" "CHROMEBOOK"
	elif use eve-kvm; then
		doappid "{75563B98-6669-53BA-9A12-D48141DA0C14}" "CHROMEBOOK"
	elif use eve-arcnext; then
		doappid "{12E4F4E4-4482-2F56-F445-7EDA56433A9A}" "CHROMEBOOK"
	elif use eve-campfire; then
		doappid "{BF8505B6-AF41-4F34-8F6D-1768FEF18753}" "CHROMEBOOK"
	else
		doappid "{01906EA2-3EB2-41F1-8F62-F0B7120EFD2E}" "CHROMEBOOK"
	fi

	# Install platform specific config files for power_manager.
	insinto "/usr/share/power_manager/board_specific"
	doins "${FILESDIR}"/powerd_prefs/*

	# Install Bluetooth ID override.
	insinto "/etc/bluetooth"
	doins "${FILESDIR}/main.conf"

	# Install audio config files
	local audio_config_dir="${FILESDIR}/audio-config"
	install_audio_configs eve "${audio_config_dir}"

	# Install platform-specific internal keyboard keymap.
	# It should probbaly go into /lib/udev/hwdb.d but
	# unfortunately udevadm on 64 bit boxes does not check
	# that directory (it wants to look in /lib64/udev).
	insinto "${EPREFIX}/etc/udev/hwdb.d"
	doins "${FILESDIR}/61-eve-keyboard.hwdb"

	# Intall a rule tagging keyboard as having updated layout
	udev_dorules "${FILESDIR}/61-eve-keyboard.rules"
}
