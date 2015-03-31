# Copyright (c) 2013 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4
CROS_WORKON_COMMIT=("78cba1794811813edf3ee9a760e8c6bfc8843f1e" "19e9e1e3e5616b0c12d63a5f91f84d7e66707ec8")
CROS_WORKON_TREE=("344e68596476568b17a6bed41b723aa6f609a9ba" "0c8c9cd3fe5c1d39907e745e0ac6933dc67efcdc")
CROS_WORKON_PROJECT=("chromiumos/third_party/coreboot" "chromiumos/platform/vboot_reference")
CROS_WORKON_LOCALNAME=("coreboot" "../platform/vboot_reference")
CROS_WORKON_DESTDIR=("${S}" "${S}/vboot_reference")

inherit cros-board cros-workon cros-coreboot

KEYWORDS="arm"

DEPEND="dev-embedded/cbootimage"

RDEPEND="chromeos-base/vboot_reference"
