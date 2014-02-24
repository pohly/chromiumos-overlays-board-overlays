# Copyright (c) 2013 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4
CROS_WORKON_COMMIT=("290edf5835fcc509f1fbde4de50852f2086daeb9" "970e781bb4ce1ca96133d2b2ceac25dfdfd1d9d2")
CROS_WORKON_TREE=("2f5b1b601bae7e19d05ac5a08dd3689dd700be52" "0e3f9cbfdca5d6a32aae5dee05f74b2a48fd4095")
CROS_WORKON_PROJECT=("chromiumos/third_party/coreboot" "chromiumos/platform/vboot_reference")
CROS_WORKON_LOCALNAME=("coreboot" "../platform/vboot_reference")
CROS_WORKON_DESTDIR=("${S}" "${S}/vboot_reference")

inherit cros-board cros-workon cros-coreboot

KEYWORDS="arm"

DEPEND="dev-embedded/cbootimage"

RDEPEND="chromeos-base/vboot_reference"
