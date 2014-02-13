# Copyright (c) 2013 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4
CROS_WORKON_COMMIT=("da0d850c90325d6c6c2415ead062a11fe6558b6f" "970e781bb4ce1ca96133d2b2ceac25dfdfd1d9d2")
CROS_WORKON_TREE=("733a2d403d48cb087b726cd8c203072dfe0b5dc2" "0e3f9cbfdca5d6a32aae5dee05f74b2a48fd4095")
CROS_WORKON_PROJECT=("chromiumos/third_party/coreboot" "chromiumos/platform/vboot_reference")
CROS_WORKON_LOCALNAME=("coreboot" "../platform/vboot_reference")
CROS_WORKON_DESTDIR=("${S}" "${S}/vboot_reference")

inherit cros-board cros-workon cros-coreboot

KEYWORDS="arm"

DEPEND="dev-embedded/cbootimage"

RDEPEND="chromeos-base/vboot_reference"
