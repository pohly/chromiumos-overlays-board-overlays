# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2.

EAPI=6

CROS_WORKON_COMMIT="eef971e60d830e2419487de6dae2b2f124616ae3"
CROS_WORKON_TREE="b2026acfd5bfc2a76517da581a2ae9a7c495c0bc"
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
