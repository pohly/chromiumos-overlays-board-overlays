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
	chromeos-base/bootstat
	chromeos-base/chromeos-installer
	chromeos-base/vboot_reference
	sys-apps/rootdev
	sys-apps/systemd
	!chromeos-base/chromeos-init
"

S="${WORKDIR}"

src_install() {
	# We want /sbin, not /usr/sbin, etc.
	into /

	# Install startup scripts.
	dosbin "${FILESDIR}"/chromeos_startup
	dosbin "${FILESDIR}"/chromeos_shutdown
	dosbin "${FILESDIR}"/clobber-state
	dosbin "${FILESDIR}"/clobber-log
	dosbin "${FILESDIR}"/chromeos-boot-alert

	systemd_dounit "${FILESDIR}"/chromeos-startup.service
	systemd_enable_service sysinit.target chromeos-startup.service
	systemd_dounit "${FILESDIR}"/chromeos-shutdown.service
	systemd_enable_service shutdown.target chromeos-shutdown.service

	systemd_newtmpfilesd "${FILESDIR}"/run-lock.tmpfiles run-lock.conf

	insinto /usr/share/cros
	doins "${FILESDIR}"/startup_utils.sh
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
