# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit appid

DESCRIPTION="Ebuild which pulls in any necessary ebuilds as dependencies
or portage actions."

LICENSE="BSD"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE="kernel-3_8"

# Add dependencies on other ebuilds from within this board overlay
RDEPEND="
	sys-apps/bootcache
	sys-apps/iotools
"
DEPEND=""

S=${WORKDIR}

src_install() {
	doappid "{9D137383-EB72-4BA9-A523-91AC0853F8AD}" "CHROMEBOOK"

	# Install platform specific config file for power_manager
	insinto "/usr/share/power_manager/board_specific"
	doins "${FILESDIR}"/powerd_prefs/*

	# Determine kernel version.
	local audio_config_dir=$FILESDIR/audio-config-$(usex kernel-3_8 3_8 3_4)

	# install alsa config files
	local board="parrot"
	insinto /etc/modprobe.d
	local alsa_conf="${audio_config_dir}/alsa-module-config/alsa-${board}.conf"
	if [[ -f "${alsa_conf}" ]] ; then
		doins "${alsa_conf}"
	fi

	# install alsa patch files
	insinto /lib/firmware
	local alsa_patch="${audio_config_dir}/alsa-module-config/${board}_alsa.fw"
	if [[ -f "${alsa_patch}" ]] ; then
		doins "${alsa_patch}"
	fi

	# install ucm config files
	insinto /usr/share/alsa/ucm
	local ucm_config="${audio_config_dir}/ucm-config"
	if [[ -d "${ucm_config}" ]] ; then
		doins -r "${ucm_config}"/*
	fi

	# install cras config files
	insinto /etc/cras
	local cras_config="${audio_config_dir}/cras-config"
	if [[ -d "${cras_config}" ]] ; then
		doins -r "${cras_config}"/*
	fi
}
