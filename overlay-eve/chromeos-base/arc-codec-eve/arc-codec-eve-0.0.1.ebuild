# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Install codec configuration for ARC++"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="!chromeos-base/arc-codec-chipset-kbl"

S="${WORKDIR}"

src_install() {
	insinto /opt/google/containers/android/vendor/etc/
	doins "${FILESDIR}/media_codecs.xml"
	doins "${FILESDIR}/media_codecs_performance.xml"
}
