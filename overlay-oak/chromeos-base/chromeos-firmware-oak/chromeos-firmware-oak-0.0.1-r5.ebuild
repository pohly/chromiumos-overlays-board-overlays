# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4
CROS_WORKON_COMMIT="8b14a26ccaaac20c33535a38199273c0acecb33f"
CROS_WORKON_TREE="cf301e953706dbc730b9c3a9410f44859eab553f"
CROS_WORKON_LOCALNAME="firmware"
CROS_WORKON_PROJECT="chromiumos/platform/firmware"

inherit cros-workon cros-firmware

DESCRIPTION="Chrome OS Firmware for Oak"
HOMEPAGE="http://src.chromium.org"
LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

# Remove other virtual packages
RDEPEND="
	!chromeos-base/chromeos-firmware-null
"

# ---------------------------------------------------------------------------
# CUSTOMIZATION SECTION

# Default firmware image files.
# To use the Binary Component Server (BCS), copy a tbz2 archive to CPFE:
#   http://www.google.com/chromeos/partner/fe/
# This archive should contain only the image file at its root.
# Examples
#  CROS_FIRMWARE_MAIN_IMAGE="bcs://filename.tbz2" - Fetch from BCS.
#  CROS_FIRMWARE_MAIN_IMAGE="${ROOT}/firmware/filename.bin" - Local file path.

# When you modify any files below, please also update manifest file in chroot:
#  ebuild-$board chromeos-firmware-$board-9999.ebuild manifest
CROS_FIRMWARE_MAIN_IMAGE="bcs://oak_fw_prerelease_0.0.22_rev5.tbz"
CROS_FIRMWARE_EC_IMAGE="bcs://oak_ec_prerelease_0.0.22_rev5.tbz"
#CROS_FIRMWARE_PD_IMAGE="bcs://oak_pd_prerelease_0.0.22_rev5.tbz"

# Stable firmware settings. Devices with firmware version smaller than stable
# version (or if stable version is empty) will get RO+RW update if write
# protection is not enabled.
CROS_FIRMWARE_STABLE_MAIN_VERSION=""
CROS_FIRMWARE_STABLE_EC_VERSION=""

# Updater configurations
CROS_FIRMWARE_SCRIPT="updater5.sh"

cros-firmware_setup_source
