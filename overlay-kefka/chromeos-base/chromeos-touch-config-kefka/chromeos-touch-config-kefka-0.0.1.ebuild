# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4

DESCRIPTION="Install firmware data for Elan chips"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

TOUCH_FW_PATH="/opt/google/touch/firmware"
TP_FW_FILE="148.0_3.0.bin"
TP_FW_LINK="/lib/firmware/elan_i2c_148.0.bin"

S=${WORKDIR}

DEPEND=""

RDEPEND="${DEPEND}
	 chromeos-base/touch_updater"

src_install() {
	insinto "${TOUCH_FW_PATH}"
	doins "${FILESDIR}/${TP_FW_FILE}"
	dosym "${TOUCH_FW_PATH}/${TP_FW_FILE}" "${TP_FW_LINK}"
}
