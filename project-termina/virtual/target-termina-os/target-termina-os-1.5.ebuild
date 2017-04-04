# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Packages for the Termina base image"
HOMEPAGE="http://dev.chromium.org/"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="
	chromeos-base/chromeos-bsp-termina
	chromeos-base/run_oci
	sys-apps/upstart
	sys-auth/pambase
	virtual/chromeos-bsp
	virtual/implicit-system
	virtual/linux-sources
"

DEPEND="
	${RDEPEND}
"
