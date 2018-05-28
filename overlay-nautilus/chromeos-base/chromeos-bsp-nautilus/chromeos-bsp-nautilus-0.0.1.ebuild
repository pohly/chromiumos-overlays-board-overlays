# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit appid cros-audio-configs

DESCRIPTION="Ebuild which pulls in any necessary ebuilds as dependencies
or portage actions."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE=""
S="${WORKDIR}"

# Add dependencies on other ebuilds from within this board overlay
RDEPEND=""
DEPEND="${RDEPEND}"

src_install() {
	doappid "{85F8FA82-F276-4EA6-8980-93FE091F6D25}" "CHROMEBOOK"
	# Install audio config files
	local audio_config_dir="${FILESDIR}/audio-config"
	install_audio_configs nautilus "${audio_config_dir}"

	# Install platform specific config files for power_manager.
	insinto "/usr/share/power_manager/board_specific"
	doins "${FILESDIR}"/powerd_prefs/*

	# Install Bluetooth ID override.
	insinto "/etc/bluetooth"
	doins "${FILESDIR}/main.conf"

	# Install cpuset adjustments.
	insinto "/opt/google/containers/android/vendor/etc/init/"
	doins "${FILESDIR}/init.cpusets.rc"
}
