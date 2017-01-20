# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

# TODO(benchan): Remove this package once we address the root cause of
# chromium:653979.

EAPI="5"

inherit udev

DESCRIPTION="Watchdog to work around modem out-of-sync issue on Kip"
HOMEPAGE="http://www.chromium.org/"
SRC_URI=""

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

DEPEND=""
RDEPEND="chromeos-base/ec-utils
	sys-apps/coreutils
	sys-apps/usbutils
	sys-apps/util-linux
	virtual/udev"

S="${WORKDIR}"

src_install() {
	exeinto "$(get_udevdir)"
	doexe "${FILESDIR}/chromeos-kip-modem-watchdog.sh"

	udev_dorules "${FILESDIR}/99-chromeos-kip-modem-watchdog.rules"
}
