# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=2

inherit cros-binary

DESCRIPTION="Multi-Format Codec Firmware Binary for Exynos5"
SLOT="0"
KEYWORDS="arm"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

URI_BASE="http://commondatastorage.googleapis.com/chromeos-localmirror/distfiles"
CROS_BINARY_URI="${URI_BASE}/${PF}.tbz2"
CROS_BINARY_SUM="68b0109b477e03e87eab1be3650dffe7025c7d6b"
CROS_BINARY_INSTALL_FLAGS="--strip-components=1"

# The tbz2 file contains the following:
# mfc-fw/lib/firmware/s5p-mfc-v6.fw
src_install() {
	dodir /lib/firmware
	cros-binary_src_install
	fowners root:root /lib/firmware/s5p-mfc-v6.fw
}
