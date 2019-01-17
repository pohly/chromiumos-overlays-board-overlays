# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CROS_WORKON_COMMIT="f9b374f1d0167bfea1d32000972e3ffa5a659516"
CROS_WORKON_TREE="ef619bbc5c512426e5da5042f12d512a571009d7"
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
