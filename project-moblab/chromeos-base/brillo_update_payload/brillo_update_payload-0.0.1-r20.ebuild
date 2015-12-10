# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="4"
CROS_WORKON_COMMIT="f0912a20b68e0bbe9e3de394c81aabdcdbef735f"
CROS_WORKON_TREE="2686169653882121470b71953a248705c6404d2d"
CROS_WORKON_PROJECT="chromiumos/platform/dev-util"
CROS_WORKON_LOCALNAME="dev"

inherit cros-workon

DESCRIPTION="Installs the brillo_update_payload script"
HOMEPAGE="http://www.chromium.org/"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND="
	!chromeos-base/cros-devutils
	app-arch/unzip
	brillo-base/libsparse
	chromeos-base/update_engine[delta_generator]
	dev-util/shflags
	"

DEPEND=""

src_install() {
	dobin host/brillo_update_payload
}
