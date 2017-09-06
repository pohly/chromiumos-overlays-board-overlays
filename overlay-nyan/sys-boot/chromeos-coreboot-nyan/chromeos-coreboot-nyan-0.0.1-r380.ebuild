# Copyright (c) 2013 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4
CROS_WORKON_COMMIT=("fe8117c866b6de03ea934be3055b017234851883" "3d6a7e4ccd3ef706fe8296e18704a3f05093fa60")
CROS_WORKON_TREE=("1edb72954eda9bf8ee5d0094e02e219e3bc1d452" "7f1520079daa8de0dce21b2bdb8e82a226ac798c")
CROS_WORKON_PROJECT=("chromiumos/third_party/coreboot" "chromiumos/platform/vboot_reference")
CROS_WORKON_LOCALNAME=("coreboot" "../platform/vboot_reference")
CROS_WORKON_DESTDIR=("${S}" "${S}/vboot_reference")

inherit cros-board cros-workon cros-coreboot

KEYWORDS="arm"

DEPEND="dev-embedded/cbootimage"

RDEPEND="chromeos-base/vboot_reference"
