# Copyright (c) 2013 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4
CROS_WORKON_COMMIT=("7ffe8f617c275368158ddc72a8317efa8dad9e74" "0038946fbea2617800ec9ffa6f95d2eea3243c3d")
CROS_WORKON_TREE=("ea4fac1182d25c5cb001d2a6ee1d097a9d0c74ad" "d7e1eca6667e786e0c3567dc8289b856ae048f99")
CROS_WORKON_PROJECT=("chromiumos/third_party/coreboot" "chromiumos/platform/vboot_reference")
CROS_WORKON_LOCALNAME=("coreboot" "../platform/vboot_reference")
CROS_WORKON_DESTDIR=("${S}" "${S}/vboot_reference")

inherit cros-board cros-workon cros-coreboot

KEYWORDS="arm"

DEPEND="dev-embedded/cbootimage"

RDEPEND="chromeos-base/vboot_reference"
