# Copyright (c) 2013 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4
CROS_WORKON_COMMIT=("646dd002fed992288353e2e60979f6f53558fc99" "a7548035646e9ed6e4164ba9d37d65c7914ae1d9")
CROS_WORKON_TREE=("835b6a4dccd7270216670ccf63fe33532c6eb21e" "7ab6b1df62c1b5c9483aa3a1a6ef4f7f70a4d2a5")
CROS_WORKON_PROJECT=("chromiumos/third_party/coreboot" "chromiumos/platform/vboot_reference")
CROS_WORKON_LOCALNAME=("coreboot" "../platform/vboot_reference")
CROS_WORKON_DESTDIR=("${S}" "${S}/vboot_reference")

inherit cros-board cros-workon cros-coreboot

KEYWORDS="arm"

DEPEND="dev-embedded/cbootimage"

RDEPEND="chromeos-base/vboot_reference"
