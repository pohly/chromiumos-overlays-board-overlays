# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Install media profiles on ARC++"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""
DEPEND="!chromeos-base/arc-media-profiles-default"
S="${WORKDIR}"

src_install() {
	insinto /opt/google/containers/android/vendor/etc/
	doins "${FILESDIR}/media_profiles.xml"
}
