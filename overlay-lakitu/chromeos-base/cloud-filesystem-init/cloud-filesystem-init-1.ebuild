# Copyright 2015 The Chromium OS Authors. All rights reserved.

EAPI=5

inherit systemd

DESCRIPTION="Make Cloud specific filesystem modifications"
HOMEPAGE=""

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

S=${WORKDIR}

RDEPEND="
	>=sys-apps/util-linux-2.27.1
"

DEST_DIRECTORY="/usr/share/cloud"

src_install() {
	# Install into /sbin
	exeinto ${DEST_DIRECTORY}
	doexe "${FILESDIR}"/mount-etc-overlay

	# Add /mnt/disks/ directory under which users can mount their PDs.
	dodir /mnt/disks

	systemd_dounit "${FILESDIR}"/mnt-disks.mount
	systemd_enable_service local-fs.target mnt-disks.mount

	systemd_dounit "${FILESDIR}"/mount-etc-overlay.service
	systemd_enable_service local-fs.target mount-etc-overlay.service

	systemd_dounit "${FILESDIR}"/var-lib-docker.mount
	systemd_dounit "${FILESDIR}"/var-lib-docker-remount.service
	systemd_enable_service local-fs.target var-lib-docker.mount
}
