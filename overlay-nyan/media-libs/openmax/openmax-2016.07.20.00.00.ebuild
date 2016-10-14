# Copyright (c) 2013 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit multilib

DESCRIPTION="OpenMAX binary libraries"

LICENSE="NVIDIA-r2"
SLOT="0"
KEYWORDS="arm"
IUSE=""

RDEPEND="~sys-apps/nvrm-${PV}
	virtual/opengles
	"

S=${WORKDIR}
