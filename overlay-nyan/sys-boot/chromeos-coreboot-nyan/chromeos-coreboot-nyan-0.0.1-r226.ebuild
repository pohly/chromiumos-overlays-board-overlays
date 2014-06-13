# Copyright (c) 2013 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4
CROS_WORKON_COMMIT=("4b4c9e7f21a2538be36b8d96385a8a66a6000b25" "0038946fbea2617800ec9ffa6f95d2eea3243c3d")
CROS_WORKON_TREE=("c7ed948538278324b1450c641abe2308b69acdaa" "d7e1eca6667e786e0c3567dc8289b856ae048f99")
CROS_WORKON_PROJECT=("chromiumos/third_party/coreboot" "chromiumos/platform/vboot_reference")
CROS_WORKON_LOCALNAME=("coreboot" "../platform/vboot_reference")
CROS_WORKON_DESTDIR=("${S}" "${S}/vboot_reference")

inherit cros-board cros-workon cros-coreboot

KEYWORDS="arm"

DEPEND="dev-embedded/cbootimage"

RDEPEND="chromeos-base/vboot_reference"
