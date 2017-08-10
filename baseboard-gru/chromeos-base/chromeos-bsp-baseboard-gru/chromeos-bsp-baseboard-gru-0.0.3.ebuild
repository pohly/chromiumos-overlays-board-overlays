# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit appid cros-audio-configs udev

DESCRIPTION="Ebuild which pulls in any necessary ebuilds as dependencies
or portage actions."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="-* arm64 arm"
S="${WORKDIR}"

RDEPEND="
	x11-drivers/mali-rules
	!media-libs/media-rules
	!<chromeos-base/chromeos-bsp-kevin-0.0.3
"
DEPEND="${RDEPEND}"

src_install() {
	# Install audio config files
	local audio_config_dir="${FILESDIR}/audio-config"
	install_audio_configs gru "${audio_config_dir}"

	# Override default CPU clock speed governor.
	insinto "/etc"
	doins "${FILESDIR}/cpufreq.conf"

	# Install cpuset adjustments.
	insinto "/etc/init"
	doins "${FILESDIR}/platform-cpusets.conf"
	insinto "/opt/google/containers/android/vendor/etc/init/"
	doins "${FILESDIR}/init.cpusets.rc"

	# Install platform specific triggers and udev rules for codecs.
	insinto "/etc/init"
	doins "${FILESDIR}/udev-trigger-codec.conf"
	udev_dorules "${FILESDIR}/50-media.rules"
}
