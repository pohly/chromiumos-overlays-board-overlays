# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2.

EAPI=6

CROS_WORKON_COMMIT="8260fcbc059081f0e94144386acbf4961708d4ba"
CROS_WORKON_TREE="2f83dccff6020c2200fd8ea80ae5d57224d3b330"
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

