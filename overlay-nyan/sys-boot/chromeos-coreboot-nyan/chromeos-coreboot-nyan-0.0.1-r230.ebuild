# Copyright (c) 2013 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4
CROS_WORKON_COMMIT=("eacedef0c059da98d973834fc751362520666ac7" "0038946fbea2617800ec9ffa6f95d2eea3243c3d")
CROS_WORKON_TREE=("009363b456a962bd85fe099a72f4f8a1a64a6b9c" "d7e1eca6667e786e0c3567dc8289b856ae048f99")
CROS_WORKON_PROJECT=("chromiumos/third_party/coreboot" "chromiumos/platform/vboot_reference")
CROS_WORKON_LOCALNAME=("coreboot" "../platform/vboot_reference")
CROS_WORKON_DESTDIR=("${S}" "${S}/vboot_reference")

inherit cros-board cros-workon cros-coreboot

KEYWORDS="arm"

DEPEND="dev-embedded/cbootimage"

RDEPEND="chromeos-base/vboot_reference"
