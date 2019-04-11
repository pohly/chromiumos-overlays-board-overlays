# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2.

EAPI=6

CROS_WORKON_COMMIT="77b6954280942791a4b80ecc6f15669f8bdfd9d5"
CROS_WORKON_TREE="88d70adcaabc4db62530c37aab7e35785e4251b8"
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

SRC_URI="${BASE_SRC_URI}/mobmonitor-ui-node_modules-0.0.2.tar.gz"

RDEPEND="
		dev-python/futures
		net-libs/grpc
		dev-python/protobuf-python
		dev-python/google-cloud-storage
"

DEPEND="${RDEPEND}
"

src_unpack() {
	cros-workon_src_unpack
	default
}

