# Copyright (c) 2011 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=2
CROS_WORKON_COMMIT="07b8e190539b3075c32b2fe5696e79d648c5561c"
CROS_WORKON_PROJECT="chromiumos/platform/firmware"

inherit cros-workon cros-firmware

DESCRIPTION="Chrome OS Firmware"
HOMEPAGE="http://www.chromium.org/"
SRC_URI=""
LICENSE="BSD"
SLOT="0"
KEYWORDS="arm"
IUSE=""

DEPEND="sys-boot/chromeos-bios"
RDEPEND="${DEPEND}"

CROS_WORKON_LOCALNAME="firmware"

# ---------------------------------------------------------------------------
# CUSTOMIZATION SECTION

# System firmware image.
CROS_FIRMWARE_MAIN_IMAGE="${ROOT}/u-boot/image.bin"
