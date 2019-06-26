# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cros-constants

CROS_WORKON_PROJECT="chromiumos/overlays/board-overlays"
CROS_WORKON_LOCALNAME="../overlays/"
CROS_WORKON_SUBTREE="overlay-drallion/chromeos-base/chromeos-config-bsp-drallion/files"

inherit cros-unibuild cros-workon

DESCRIPTION="Chrome OS Model configuration package for drallion."

LICENSE="BSD-Google"
SLOT="0/${PF}"
KEYWORDS="~* ~amd64 ~x86"

src_install() {
	install_model_files
}
