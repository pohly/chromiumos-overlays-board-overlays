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
RDEPEND="
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
	systemd_dounit "${FILESDIR}"/check-secure-boot.service
	systemd_enable_service multi-user.target check-secure-boot.service
	systemd_dounit "${FILESDIR}"/prep-logs-dev@.service

	systemd_newtmpfilesd "${FILESDIR}"/chromeos-init.tmpfiles chromeos-init.conf

	insinto "$(systemd_get_unitdir)/sys-kernel-debug.mount.d"
	newins "${FILESDIR}"/sys-kernel-debug-lakitu.conf lakitu.conf

	insinto "$(systemd_get_unitdir)/tmp.mount.d"
	newins "${FILESDIR}"/tmp-lakitu.conf lakitu.conf

	exeinto "$(systemd_get_unitdir)-generators"
	doexe "${FILESDIR}"/chromeos-mount-generator

	insinto "$(systemd_get_unitdir)/update-engine.service.d"
	newins "${FILESDIR}"/update-engine-secure-boot.conf secure-boot.conf

	# Upstream crash-sender.service has a random delay up to 6 minutes.
	# The drop-in file forces immediate uploading by setting max_spread_time=0.
	insinto "$(systemd_get_unitdir)/crash-sender.service.d"
	newins "${FILESDIR}"/crash-sender-send-immediately.conf send-immediately.conf

	exeinto "/usr/share/cloud"
	doexe "${FILESDIR}"/stateful-dev-sym-sorted
	doexe "${FILESDIR}"/is-secure-boot
	doexe "${FILESDIR}"/prep-logs-dev
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
