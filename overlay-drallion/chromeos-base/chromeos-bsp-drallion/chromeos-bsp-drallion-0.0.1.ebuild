# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit appid cros-unibuild

DESCRIPTION="Drallion board-specific ebuild that pulls in necessary ebuilds as
dependencies or portage actions."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="* amd64 x86"
S="${WORKDIR}"

src_install() {
	doappid "{ED3A4869-C380-4F79-A190-027C3E879357}" "CHROMEBOOK"
}
