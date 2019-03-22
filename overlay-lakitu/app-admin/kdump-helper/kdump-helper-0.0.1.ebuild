# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=6

DESCRIPTION="Implementation for lakitu's kdump functionality."

inherit systemd

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	sys-apps/makedumpfile
	sys-apps/systemd
"

S="${WORKDIR}"

src_install() {
	systemd_dounit "${FILESDIR}"/kdump-save-dump.service
	systemd_dounit "${FILESDIR}"/kdump-load-kernel.service
	systemd_enable_service sysinit.target kdump-load-kernel.service

	exeinto /usr/sbin
	doexe "${FILESDIR}"/kdump_helper
}
