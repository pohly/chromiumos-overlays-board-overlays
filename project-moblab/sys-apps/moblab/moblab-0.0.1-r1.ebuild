# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2.

EAPI=6

CROS_WORKON_COMMIT="400fee63fb2dfd13ffc9a7dfb908efd5d7303998"
CROS_WORKON_TREE="cadc1c565b19eda39dea5e9097342a1460ef1395"
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

