# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2.

EAPI=6

CROS_WORKON_COMMIT="6f7a57b70c944c5bbd52df8af109ae41443b2d3c"
CROS_WORKON_TREE="ff1765f388f0b62416964f7cef05704b5f78bbe9"
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_PROJECT="chromiumos/platform/moblab"
CROS_WORKON_LOCALNAME="../platform/moblab"

inherit cros-workon

DESCRIPTION="Autotest site_utils specific to Moblab"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/moblab/+/master/src/tools"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="chromeos-base/autotest-server"

DEPEND="
	${RDEPEND}
"

src_install() {
	insinto /autotest/site_utils
	doins src/tools/*.py
}