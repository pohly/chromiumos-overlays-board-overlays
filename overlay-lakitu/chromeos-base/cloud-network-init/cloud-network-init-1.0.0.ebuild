# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=5

inherit systemd

DESCRIPTION="Initialization for various cloud network services"
HOMEPAGE=""

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S=${WORKDIR}

src_install() {
	systemd_dounit "${FILESDIR}"/gcr-wait-online.service
	systemd_dounit "${FILESDIR}"/gcr-online.target
	systemd_enable_service gcr-online.target gcr-wait-online.service

	exeinto /usr/share/cloud
	doexe "${FILESDIR}"/wait_for_user_data.sh
	systemd_dounit "${FILESDIR}"/user-data-wait-online.service
	systemd_dounit "${FILESDIR}"/user-data-online.target
	systemd_enable_service user-data-online.target user-data-wait-online.service
}
