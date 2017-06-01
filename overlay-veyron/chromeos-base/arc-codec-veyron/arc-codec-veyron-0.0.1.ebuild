# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4

DESCRIPTION="Install codec configuration for ARC++"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="android-container-nyc"
S="${WORKDIR}"

src_install() {
	if use android-container-nyc; then
		ARC_CODEC_DIR="${FILESDIR}/nyc"
	else
		ARC_CODEC_DIR="${FILESDIR}/mnc"
	fi

	insinto /opt/google/containers/android/vendor/etc/
	doins "${ARC_CODEC_DIR}/media_codecs.xml"
	doins "${ARC_CODEC_DIR}/media_codecs_performance.xml"
}
