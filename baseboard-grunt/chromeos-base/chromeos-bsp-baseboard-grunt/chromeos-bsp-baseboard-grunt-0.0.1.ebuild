# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Pulls in any necessary ebuilds as dependencies or portage actions."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="-* amd64 x86"
S="${WORKDIR}"

# Add dependencies on other ebuilds from within this board overlay
RDEPEND=""
DEPEND="${RDEPEND}"
