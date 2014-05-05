# Copyright (c) 2013 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4
CROS_WORKON_COMMIT=("7e9f7eb60250cee54c647799b95698e4cd755358" "a7548035646e9ed6e4164ba9d37d65c7914ae1d9")
CROS_WORKON_TREE=("07bb7fc91d52443bb7900f84a3ad1ebf1817ee2c" "7ab6b1df62c1b5c9483aa3a1a6ef4f7f70a4d2a5")
CROS_WORKON_PROJECT=("chromiumos/third_party/coreboot" "chromiumos/platform/vboot_reference")
CROS_WORKON_LOCALNAME=("coreboot" "../platform/vboot_reference")
CROS_WORKON_DESTDIR=("${S}" "${S}/vboot_reference")

inherit cros-board cros-workon cros-coreboot

KEYWORDS="arm"

DEPEND="dev-embedded/cbootimage"

RDEPEND="chromeos-base/vboot_reference"
