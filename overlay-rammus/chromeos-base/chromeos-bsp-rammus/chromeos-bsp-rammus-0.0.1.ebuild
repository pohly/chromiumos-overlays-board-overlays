# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=5

inherit appid cros-unibuild udev

DESCRIPTION="Ebuild which pulls in any necessary ebuilds as dependencies
or portage actions."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE=""
S="${WORKDIR}"

# Add dependencies on other ebuilds from within this board overlay
RDEPEND=""
DEPEND="
	${RDEPEND}
	chromeos-base/chromeos-config
"

src_install() {
	doappid "{625849FA-56A0-4E67-9163-B89BE0C2A6AE}" "CHROMEBOOK"

	unibuild_install_audio_files
	unibuild_install_thermal_files

	insinto "/etc/bluetooth"
	doins "${FILESDIR}/common/bluetooth/main.conf"

	udev_dorules "${FILESDIR}/99-chromeos-rammus-usb-charge-mode.rules"
}
