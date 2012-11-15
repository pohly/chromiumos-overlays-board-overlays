# Copyright (c) 2011 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2
CROS_WORKON_COMMIT="52f5a23f65d73e7b0643bef9a6a3837696d48156"
CROS_WORKON_TREE="cdee8e2cd8ab6798756d105d71ca14a7f4e99a72"

EAPI=2
CROS_WORKON_PROJECT="chromiumos/platform/firmware"

inherit cros-workon cros-firmware

CROS_WORKON_LOCALNAME="firmware"

DESCRIPTION="Chrome OS Firmware"
HOMEPAGE="http://www.chromium.org/"
LICENSE="BSD"
SLOT="0"
KEYWORDS="arm"
IUSE=""

DEPEND="${DEPEND} sys-boot/chromeos-bootimage"
SRC_URI=""

# ---------------------------------------------------------------------------
# CUSTOMIZATION SECTION

# Remove the tegra2_ prefix from board name and capitalize it.
# TODO(hungte) support boards with more variants postfix like -xx or _yy.
BOARD="${BOARD:-${SYSROOT##/build/}}"
BOARD_NAME="${BOARD##*_}"
CROS_FIRMWARE_PLATFORM="${CROS_FIRMWARE_PLATFORM:-${BOARD_NAME^*}}"

# Use v3 updater
CROS_FIRMWARE_SCRIPT="updater3.sh"
CROS_FIRMWARE_UNSTABLE="TRUE"

# System firmware image.
CROS_FIRMWARE_MAIN_IMAGE="${ROOT}/firmware/image-${BOARD_NAME}.bin"

# TODO(sjg@chromium.org): Remove this when this change goes in:
# https://gerrit.chromium.org/gerrit/25151
if [ ! -r "${CROS_FIRMWARE_MAIN_IMAGE}" ]; then
	CROS_FIRMWARE_MAIN_IMAGE="${ROOT}/firmware/image.bin"
fi
CROS_FIRMWARE_EXTRA_LIST="${FILESDIR}/extra"
