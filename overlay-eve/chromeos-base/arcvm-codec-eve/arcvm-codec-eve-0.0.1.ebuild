# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit arc-build-constants

DESCRIPTION="Install codec configuration on ARCVM"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="!chromeos-base/arcvm-codec-software"

S="${WORKDIR}"

src_install() {
	arc-build-constants-configure
	insinto "${ARC_VENDOR_DIR}/etc/"
	doins "${FILESDIR}"/*
}
