# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit cros-constants

DESCRIPTION="Install codec configuration for ARC++"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="android-container-pi"
S="${WORKDIR}"

src_install() {
	insinto "${ARC_VENDOR_DIR}/etc/"

	if use android-container-pi; then
		ARC_CODEC_DIR="${FILESDIR}/pic"
		doins "${ARC_CODEC_DIR}/media_codecs_c2.xml"
	else
		ARC_CODEC_DIR="${FILESDIR}/nyc"
	fi

	doins "${ARC_CODEC_DIR}/media_codecs.xml"
	doins "${ARC_CODEC_DIR}/media_codecs_performance.xml"
}
