# Copyright (c) 2013 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4
CROS_WORKON_COMMIT=("fef4a6b8f866a582e40dd3895a4ecd8bce89a6dc" "3d6a7e4ccd3ef706fe8296e18704a3f05093fa60")
CROS_WORKON_TREE=("bd170099b594f2d3c8983929dcbb4fc857f4639b" "7f1520079daa8de0dce21b2bdb8e82a226ac798c")
CROS_WORKON_PROJECT=("chromiumos/third_party/coreboot" "chromiumos/platform/vboot_reference")
CROS_WORKON_LOCALNAME=("coreboot" "../platform/vboot_reference")
CROS_WORKON_DESTDIR=("${S}" "${S}/vboot_reference")

inherit cros-board cros-workon cros-coreboot

KEYWORDS="arm"

DEPEND="dev-embedded/cbootimage"

RDEPEND="chromeos-base/vboot_reference"
