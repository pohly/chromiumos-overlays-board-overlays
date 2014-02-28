# Copyright (c) 2013 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4
CROS_WORKON_COMMIT=("70181f77cf2f81e6d4ad0afd07646e5f7325a06d" "970e781bb4ce1ca96133d2b2ceac25dfdfd1d9d2")
CROS_WORKON_TREE=("afa03d3b7cfb09ef05f2d2ae79250bd9f32c0b65" "0e3f9cbfdca5d6a32aae5dee05f74b2a48fd4095")
CROS_WORKON_PROJECT=("chromiumos/third_party/coreboot" "chromiumos/platform/vboot_reference")
CROS_WORKON_LOCALNAME=("coreboot" "../platform/vboot_reference")
CROS_WORKON_DESTDIR=("${S}" "${S}/vboot_reference")

inherit cros-board cros-workon cros-coreboot

KEYWORDS="arm"

DEPEND="dev-embedded/cbootimage"

RDEPEND="chromeos-base/vboot_reference"
