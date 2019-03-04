# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="MediaTek 3A library binaries required by the MediaTek camera HAL"

LICENSE="LICENCE.mediatek"
SLOT="0"
KEYWORDS="-* arm arm64"

S="${WORKDIR}"

src_install() {
	dolib.so "${FILESDIR}"/*.so*
}
