# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit udev

DESCRIPTION="Ebuild which pulls in any necessary ebuilds as dependencies
or portage actions."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="-* arm64 arm"
S="${WORKDIR}"
IUSE="cheets"

# Add dependencies on other ebuilds from within this board overlay
DEPEND="
	!media-libs/media-rules
"
RDEPEND="${DEPEND}"

src_install() {
	insinto "/etc/init"
	doins "${FILESDIR}/platform-cpusets.conf"

	# Install platform specific triggers and udev rules for codecs.
	doins "${FILESDIR}/udev-trigger-codec.conf"
	udev_dorules "${FILESDIR}/50-media.rules"

	if use cheets; then
		insinto "/opt/google/containers/android/vendor/etc/init"
		doins "${FILESDIR}/init.cpusets.rc"
	fi
}
