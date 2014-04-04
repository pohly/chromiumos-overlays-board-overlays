# Copyright (c) 2013 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4
CROS_WORKON_COMMIT=("01fb72692b41580f482648c736c581ef4610a1c9" "a7548035646e9ed6e4164ba9d37d65c7914ae1d9")
CROS_WORKON_TREE=("8506910300efc8096da4ff69b650db99b32536ea" "7ab6b1df62c1b5c9483aa3a1a6ef4f7f70a4d2a5")
CROS_WORKON_PROJECT=("chromiumos/third_party/coreboot" "chromiumos/platform/vboot_reference")
CROS_WORKON_LOCALNAME=("coreboot" "../platform/vboot_reference")
CROS_WORKON_DESTDIR=("${S}" "${S}/vboot_reference")

inherit cros-board cros-workon cros-coreboot

KEYWORDS="arm"

DEPEND="dev-embedded/cbootimage"

RDEPEND="chromeos-base/vboot_reference"
