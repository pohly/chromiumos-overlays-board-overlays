# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

DESCRIPTION="Generic ebuild which satisfies virtual/chromeos-ec-driver
This is a direct dependency of chromeos-base/chromeos-accelerometer-init,
and it is overridden in private overlay to load cros-ec stack for special ECs."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/ec/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="chromeos-base/chromeos-ec-driver-init"
