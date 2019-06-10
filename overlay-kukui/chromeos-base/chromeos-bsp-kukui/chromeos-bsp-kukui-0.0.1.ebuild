# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=5

inherit appid cros-unibuild

DESCRIPTION="Ebuild which pulls in any necessary ebuilds as dependencies
or portage actions."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="-* arm64 arm"
IUSE=""
S="${WORKDIR}"

# Add dependencies on other ebuilds from within this board overlay
RDEPEND="
	chromeos-base/chromeos-config
	chromeos-base/chromeos-bsp-baseboard-kukui
"
DEPEND="${RDEPEND}"

src_install() {
	doappid "{50F3C95B-CA5B-4AF8-87A2-8CD19588BD12}" "CHROMEBOOK"

	# Install Bluetooth ID override
	insinto "/etc/bluetooth"
	doins "${FILESDIR}/main.conf"

	# Install audio config
	unibuild_install_audio_files
}
