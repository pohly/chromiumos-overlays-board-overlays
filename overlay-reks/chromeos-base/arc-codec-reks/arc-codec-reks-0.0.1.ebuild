# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit cros-constants

DESCRIPTION="Install codec configuration for ARC++"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="!chromeos-base/arc-codec-chipset-bsw"

S="${WORKDIR}"

src_install() {
	insinto "${ARC_VENDOR_DIR}/etc/"
	doins "${FILESDIR}/media_codecs.xml"
	doins "${FILESDIR}/media_codecs_performance.xml"
}
