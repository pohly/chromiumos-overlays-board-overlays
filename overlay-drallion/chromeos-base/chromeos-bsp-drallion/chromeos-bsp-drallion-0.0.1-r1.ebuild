# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CROS_WORKON_COMMIT="f52eea3688985f0af419434320c2d15449e8dc67"
CROS_WORKON_TREE="None"
inherit appid

CROS_WORKON_PROJECT="chromiumos/overlays/board-overlays"
CROS_WORKON_LOCALNAME="../overlays/"
CROS_WORKON_SUBTREE="overlay-drallion/chromeos-base/chromeos-bsp-drallion/files"

inherit cros-unibuild cros-workon

DESCRIPTION="Drallion board-specific ebuild that pulls in necessary ebuilds as
dependencies or portage actions."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="* amd64 x86"

src_install() {
	doappid "{ED3A4869-C380-4F79-A190-027C3E879357}" "CHROMEBOOK"
}
