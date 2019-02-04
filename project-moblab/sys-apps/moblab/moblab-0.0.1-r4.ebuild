# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2.

EAPI=6

CROS_WORKON_COMMIT="0d8f7a61e4c146cabceea5f81a5e26d6d0f5ac83"
CROS_WORKON_TREE="438603e99be171968d03f273689cace9ab624545"
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

