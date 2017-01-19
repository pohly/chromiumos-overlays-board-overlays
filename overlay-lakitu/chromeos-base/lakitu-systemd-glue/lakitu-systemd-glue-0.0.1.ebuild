# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=5

inherit systemd

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="
	!chromeos-base/chromeos-init[-systemd]
	!<sys-apps/systemd-221-r4
	sys-fs/inotify-tools
"
DEPEND=""

S="${WORKDIR}"

src_install() {
	insinto /etc/init
	doins "${FILESDIR}"/dbus.conf

	systemd_dounit "${FILESDIR}"/dbus-notify.service
	systemd_enable_service multi-user.target dbus-notify.service

	systemd_dounit "${FILESDIR}"/upstart-halt.service
	systemd_enable_service poweroff.target upstart-halt.service
}
