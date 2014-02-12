# Copyright (c) 2013 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4
CROS_WORKON_COMMIT=("d7ce80a92616ff5a6a5b003cf5db4f36257b4243" "970e781bb4ce1ca96133d2b2ceac25dfdfd1d9d2")
CROS_WORKON_TREE=("5abd38ed521cb7bc4959e9cc2ef44ed7a50b7836" "0e3f9cbfdca5d6a32aae5dee05f74b2a48fd4095")
CROS_WORKON_PROJECT=("chromiumos/third_party/coreboot" "chromiumos/platform/vboot_reference")
CROS_WORKON_LOCALNAME=("coreboot" "../platform/vboot_reference")
CROS_WORKON_DESTDIR=("${S}" "${S}/vboot_reference")

inherit cros-board cros-workon cros-coreboot

KEYWORDS="arm"

DEPEND="dev-embedded/cbootimage"

RDEPEND="chromeos-base/vboot_reference"
