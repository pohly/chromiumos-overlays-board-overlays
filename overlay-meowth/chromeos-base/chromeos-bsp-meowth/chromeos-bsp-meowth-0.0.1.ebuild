# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=5

inherit appid

DESCRIPTION="Meowth board-specific ebuild that pulls in necessary ebuilds as
dependencies or portage actions."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE=""
S="${WORKDIR}"

# Add dependencies on other ebuilds from within this board overlay
DEPEND=""

RDEPEND="${DEPEND}"

src_install() {
	doappid "{BA7F2ABA-8567-476F-B1CC-BC1C60404FEC}" "CHROMEBOOK"
}
