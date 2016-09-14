# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4

DESCRIPTION="Install OEM specific data for Genius app"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="!chromeos-base/genius-app-oem"
DEPEND="${RDEPEND}"

S=${WORKDIR}

src_install() {
	insinto "/usr/share/chromeos-assets/genius_app/embedded_device_content"

	doins -r "${FILESDIR}"/*
}
