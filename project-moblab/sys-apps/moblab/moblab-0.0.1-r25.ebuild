# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2.

EAPI=6

CROS_WORKON_COMMIT="6dbaf004c4e8be00ed9d5717dd07e3f41a9c385f"
CROS_WORKON_TREE="0a2baa4c99dacf7a7a6cebfb070f845473800182"
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
IUSE="docker"

SRC_URI="${BASE_SRC_URI}/mobmonitor-ui-node_modules-0.0.2.tar.gz"

RDEPEND="
		docker? ( app-emulation/docker )
		dev-python/futures
		dev-python/google-cloud-storage
		dev-python/grpcio
		dev-python/protobuf-python
		net-libs/grpc
"

DEPEND="${RDEPEND}
"

src_unpack() {
	cros-workon_src_unpack
	default
}

