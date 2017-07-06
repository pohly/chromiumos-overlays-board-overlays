# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI="5"

inherit systemd user

DESCRIPTION="Dev image init scripts for Lakitu"
HOMEPAGE=""
SRC_URI=""

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="${DEPEND}
	sys-apps/systemd
"

S="${WORKDIR}"

src_install() {
	systemd_dounit "${FILESDIR}"/usr-local.mount
	systemd_enable_service local-fs.target usr-local.mount
	systemd_dounit "${FILESDIR}"/usr-local-remount.service

	systemd_newtmpfilesd "${FILESDIR}"/dev-image.tmpfiles dev-image.conf

	systemd_enable_service getty.target serial-getty@ttyS1.service
}
