# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Packages for the Termina base image"
HOMEPAGE="http://dev.chromium.org/"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="-runc"

# TODO: Remove termina-sshd-init once API is ready: crbug.com/790728
RDEPEND="
	app-arch/tar
	app-emulation/lxd
	chromeos-base/chromeos-bsp-termina
	chromeos-base/run_oci
	chromeos-base/termina-lxd-scripts
	chromeos-base/termina-sshd-init
	chromeos-base/vm_tools
	net-fs/nfs-utils
	runc? ( app-emulation/runc )
	sys-apps/iproute2
	sys-auth/pambase
	virtual/chromeos-bsp
	virtual/implicit-system
	virtual/linux-sources
"

DEPEND="
	${RDEPEND}
"
