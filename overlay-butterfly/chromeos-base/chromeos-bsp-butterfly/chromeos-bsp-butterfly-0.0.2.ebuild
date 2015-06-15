# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="4"

inherit appid

DESCRIPTION="Butterfly public bsp (meta package to pull in driver/tool dependencies)"
LICENSE="BSD"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE=""

RDEPEND="
	!<chromeos-base/chromeos-bsp-butterfly-private-0.0.2
"

S=${WORKDIR}

src_install() {
	doappid "{6372E332-9A26-4CE3-9C39-93D8A4E383AF}" "CHROMEBOOK"

	# Install platform specific config file for power_manager
	insinto "/usr/share/power_manager/board_specific"
	doins "${FILESDIR}"/powerd_prefs/*

	# Install board-specific info.
	insinto "/etc/laptop-mode/conf.d/board-specific"
	doins "${FILESDIR}/runtime-pm.conf"
	doins "${FILESDIR}/intel-hda-powersave.conf"

	# install alsa config files
	local board="butterfly"
	insinto /etc/modprobe.d
	local alsa_conf="${FILESDIR}/alsa-module-config/alsa-${board}.conf"
	if [[ -f "${alsa_conf}" ]] ; then
		doins "${alsa_conf}"
	fi

	# install alsa patch files
	insinto /lib/firmware
	local alsa_patch="${FILESDIR}/alsa-module-config/${board}_alsa.fw"
	if [[ -f "${alsa_patch}" ]] ; then
		doins "${alsa_patch}"
	fi

	# install ucm config files
	insinto /usr/share/alsa/ucm
	local ucm_config="${FILESDIR}/ucm-config"
	if [[ -d "${ucm_config}" ]] ; then
		doins -r "${ucm_config}"/*
	fi

	# install cras config files
	insinto /etc/cras
	local cras_config="${FILESDIR}/cras-config"
	if [[ -d "${cras_config}" ]] ; then
		doins -r "${cras_config}"/*
	fi
}
