# Copyright (c) 2013 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4
CROS_WORKON_COMMIT=("dd6066301a8ae209a2cd2fd7b68ba12432bf0461" "0038946fbea2617800ec9ffa6f95d2eea3243c3d")
CROS_WORKON_TREE=("8736924038913d6242805de13741c71f1f555e73" "d7e1eca6667e786e0c3567dc8289b856ae048f99")
CROS_WORKON_PROJECT=("chromiumos/third_party/coreboot" "chromiumos/platform/vboot_reference")
CROS_WORKON_LOCALNAME=("coreboot" "../platform/vboot_reference")
CROS_WORKON_DESTDIR=("${S}" "${S}/vboot_reference")

inherit cros-board cros-workon cros-coreboot

KEYWORDS="arm"

DEPEND="dev-embedded/cbootimage"

RDEPEND="chromeos-base/vboot_reference"
