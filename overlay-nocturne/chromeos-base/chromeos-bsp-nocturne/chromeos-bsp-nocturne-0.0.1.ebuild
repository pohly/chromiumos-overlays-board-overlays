# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=5

inherit appid

DESCRIPTION="Nocturne board-specific ebuild that pulls in necessary ebuilds as
dependencies or portage actions."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE=""
S="${WORKDIR}"

# Add dependencies on other ebuilds from within this board overlay
RDEPEND="
	chromeos-base/chromeos-bsp-baseboard-poppy
"
DEPEND="${RDEPEND}"

src_install() {
	doappid "{BD7F7139-CC18-49C1-A847-33F155CCBCA8}" "CHROMEBOOK"
}
