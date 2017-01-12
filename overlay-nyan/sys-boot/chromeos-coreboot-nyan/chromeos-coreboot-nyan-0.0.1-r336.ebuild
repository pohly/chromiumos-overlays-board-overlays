# Copyright (c) 2013 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4
CROS_WORKON_COMMIT=("a74ecf8ad7bd12687fb34e7cc247a12f82cd4e37" "43c6f1f06daadac27edc6e1c15ce9c9fa46271e4")
CROS_WORKON_TREE=("2cc593494b1a514b199d6047777fd5dd522ff9d3" "c4ab0abb45a4334de91330cdc5970ade22ba1a67")
CROS_WORKON_PROJECT=("chromiumos/third_party/coreboot" "chromiumos/platform/vboot_reference")
CROS_WORKON_LOCALNAME=("coreboot" "../platform/vboot_reference")
CROS_WORKON_DESTDIR=("${S}" "${S}/vboot_reference")

inherit cros-board cros-workon cros-coreboot

KEYWORDS="arm"

DEPEND="dev-embedded/cbootimage"

RDEPEND="chromeos-base/vboot_reference"
