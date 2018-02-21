# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2.

EAPI=5

CROS_WORKON_COMMIT="70724f4c21ffc5e9e83d566a9b7d9d4397afa4b0"
CROS_WORKON_TREE="b89cba262a53d1a21c60c9be22854b14857115ec"
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
