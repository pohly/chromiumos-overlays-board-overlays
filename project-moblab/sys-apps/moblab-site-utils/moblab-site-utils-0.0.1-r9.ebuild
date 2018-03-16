# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2.

EAPI=6

CROS_WORKON_COMMIT="a1a49d24b83530324115641ef0dfa61d98d9197d"
CROS_WORKON_TREE="4a39dab87852443359c691b488ed2f8bd09e0314"
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
