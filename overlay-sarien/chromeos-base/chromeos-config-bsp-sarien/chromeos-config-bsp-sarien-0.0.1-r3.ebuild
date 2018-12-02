# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CROS_WORKON_COMMIT="afbba424a5cc15b741f48fab6b8348a2da11a7ce"
CROS_WORKON_TREE="3428e8d94b255d079d4dbe3bf7a9c7e5f6b042f3"
inherit cros-constants

CROS_WORKON_PROJECT="chromiumos/overlays/board-overlays"
CROS_WORKON_LOCALNAME="../overlays/"
CROS_WORKON_SUBTREE="overlay-sarien/chromeos-base/chromeos-config-bsp-sarien/files"

inherit cros-unibuild cros-workon

DESCRIPTION="Chrome OS Model configuration package for sarien"
HOMEPAGE="http://src.chromium.org"

LICENSE="BSD-Google"
SLOT="0/${PF}"
KEYWORDS="* amd64 x86"

src_install() {
	install_model_files
}
