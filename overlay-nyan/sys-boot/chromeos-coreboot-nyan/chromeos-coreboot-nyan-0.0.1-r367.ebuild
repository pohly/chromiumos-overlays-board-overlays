# Copyright (c) 2013 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4
CROS_WORKON_COMMIT=("dc70d714627f9cd565c807c5f20a30e04eccf389" "19e9e1e3e5616b0c12d63a5f91f84d7e66707ec8")
CROS_WORKON_TREE=("40e2317b15028a4119f3e84493318a836e7daa9e" "0c8c9cd3fe5c1d39907e745e0ac6933dc67efcdc")
CROS_WORKON_PROJECT=("chromiumos/third_party/coreboot" "chromiumos/platform/vboot_reference")
CROS_WORKON_LOCALNAME=("coreboot" "../platform/vboot_reference")
CROS_WORKON_DESTDIR=("${S}" "${S}/vboot_reference")

inherit cros-board cros-workon cros-coreboot

KEYWORDS="arm"

DEPEND="dev-embedded/cbootimage"

RDEPEND="chromeos-base/vboot_reference"
