# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

CROS_WORKON_COMMIT="6b374154a2f7f05a5a3dfec3b3a1d363b7edd92f"
CROS_WORKON_TREE="3428e8d94b255d079d4dbe3bf7a9c7e5f6b042f3"
inherit cros-constants

CROS_WORKON_PROJECT="chromiumos/overlays/board-overlays"
CROS_WORKON_LOCALNAME="../overlays/"
CROS_WORKON_SUBTREE="overlay-zork/chromeos-base/chromeos-config-bsp-zork/files"

inherit cros-unibuild cros-workon

DESCRIPTION="Chrome OS Model configuration package for zork"
HOMEPAGE="http://src.chromium.org"

LICENSE="BSD-Google"
SLOT="0/${PF}"
KEYWORDS="* amd64 x86"

src_install() {
	install_model_files
}
