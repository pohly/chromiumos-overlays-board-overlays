# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI="5"

inherit systemd user

DESCRIPTION="Init scripts for Lakitu"
HOMEPAGE=""
SRC_URI=""

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

# vboot_reference for crossystem
RDEPEND="${DEPEND}
	chromeos-base/chromeos-installer
	chromeos-base/vboot_reference
	sys-apps/rootdev
	sys-apps/systemd
	sys-apps/system-sysdaemons
"

S="${WORKDIR}"

src_install() {
	# We want /sbin, not /usr/sbin, etc.
	into /

	dosbin "${FILESDIR}"/chromeos_shutdown
	systemd_dounit "${FILESDIR}"/chromeos-shutdown.service
	systemd_enable_service shutdown.target chromeos-shutdown.service

	systemd_dounit "${FILESDIR}"/home.mount
	systemd_enable_service local-fs.target home.mount
	systemd_dounit "${FILESDIR}"/var.mount
	systemd_enable_service local-fs.target var.mount
	systemd_dounit "${FILESDIR}"/mnt-stateful_partition-make-private.service
	systemd_dounit "${FILESDIR}"/dev-shm-remount.service
	systemd_enable_service local-fs.target dev-shm-remount.service

	systemd_newtmpfilesd "${FILESDIR}"/chromeos-init.tmpfiles chromeos-init.conf

	insinto $(systemd_get_unitdir)/sys-kernel-debug.mount.d
	newins "${FILESDIR}"/sys-kernel-debug-lakitu.conf lakitu.conf

	exeinto $(systemd_get_unitdir)-generators
	doexe "${FILESDIR}"/chromeos-mount-generator
}

pkg_preinst() {
	# Add the syslog user
	# TODO: this should not be necessary. Remove.
	enewuser syslog
	enewgroup syslog

	# Create debugfs-access user and group, which is needed by the
	# chromeos_startup script to mount /sys/kernel/debug.  This is needed
	# by bootstat and ureadahead.
	enewuser "debugfs-access"
	enewgroup "debugfs-access"
}
