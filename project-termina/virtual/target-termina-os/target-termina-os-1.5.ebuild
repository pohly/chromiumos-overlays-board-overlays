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
	app-arch/bzip2
	app-arch/gzip
	app-arch/tar
	app-arch/xz-utils
	app-emulation/lxd
	chromeos-base/chromeos-bsp-termina
	chromeos-base/minijail
	chromeos-base/termina_container_tools
	chromeos-base/termina-lxd-scripts
	chromeos-base/vm_guest_tools
	sys-apps/iproute2
	sys-auth/pambase
	virtual/chromeos-bsp
	virtual/implicit-system
	virtual/linux-sources
"

DEPEND="
	${RDEPEND}
"
