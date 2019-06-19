# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Install upstart file to load ISH drivers"
LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

S=${WORKDIR}

src_install() {
	insinto /etc/init
	doins "${FILESDIR}"/init/cros-ec-driver.conf
}
