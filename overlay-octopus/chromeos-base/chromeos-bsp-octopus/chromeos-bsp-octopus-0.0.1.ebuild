# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=5

inherit appid

DESCRIPTION="Octopus board-specific ebuild that pulls in necessary ebuilds as
dependencies or portage actions."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE=""
S="${WORKDIR}"

# Add dependencies on other ebuilds from within this board overlay
RDEPEND="
	chromeos-base/chromeos-bsp-baseboard-octopus
"
DEPEND="${RDEPEND}"

src_install() {
	doappid "{9A3BE5D2-C3DC-4AE6-9943-E2C113895DC5}" "CHROMEBOOK"

	# Install board-specific config files for power_manager.
	insinto "/usr/share/power_manager/board_specific"
	# Since these are by definition shared by all models supported by board,
	# we insist that
	#   a) they must be in the common root model shared by all models.
	#      By convention it must be called "common".
	doins "${FILESDIR}/common/powerd"/*
}
