# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2.

EAPI=6

CROS_WORKON_COMMIT="a8c29275657a3c4209394dd5cf496215621133f8"
CROS_WORKON_TREE="096ed3c94656cd01e773e3444e8758bd1186be1d"
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_PROJECT="chromiumos/platform/moblab"
CROS_WORKON_LOCALNAME="../platform/moblab"

inherit cros-workon

DESCRIPTION="Install moblab, a test scheduling infrastructure"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/moblab/+/master/src/"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

SRC_URI="${BASE_SRC_URI}/mobmonitor-ui-node_modules-0.0.1.tar.gz"

RDEPEND="
		!!sys-apps/mobmonitor
		!!sys-apps/mobmonitor-ui
		!!sys-apps/moblab-site-utils
		!!sys-apps/moblab-upstart-init
"
DEPEND="${RDEPEND}
"

src_unpack() {
	cros-workon_src_unpack
	default
}

