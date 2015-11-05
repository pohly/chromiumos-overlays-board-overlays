# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="4"
CROS_WORKON_COMMIT="1b5810db5f64d93cca7ef8a66b82cdacb9ffb962"
CROS_WORKON_TREE="118d223809baedace81f886e812f579f4b18a07a"
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
