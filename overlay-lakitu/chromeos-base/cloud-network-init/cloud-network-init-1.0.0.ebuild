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
}
