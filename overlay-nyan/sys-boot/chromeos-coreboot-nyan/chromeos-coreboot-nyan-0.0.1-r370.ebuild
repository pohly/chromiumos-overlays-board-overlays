# Copyright (c) 2013 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4
CROS_WORKON_COMMIT=("0769788c5d69ab26f71ecf229344d9031f01b058" "19e9e1e3e5616b0c12d63a5f91f84d7e66707ec8")
CROS_WORKON_TREE=("3f46dfd360f1d823bd74a12dcd3126847d810f22" "0c8c9cd3fe5c1d39907e745e0ac6933dc67efcdc")
CROS_WORKON_PROJECT=("chromiumos/third_party/coreboot" "chromiumos/platform/vboot_reference")
CROS_WORKON_LOCALNAME=("coreboot" "../platform/vboot_reference")
CROS_WORKON_DESTDIR=("${S}" "${S}/vboot_reference")

inherit cros-board cros-workon cros-coreboot

KEYWORDS="arm"

DEPEND="dev-embedded/cbootimage"

RDEPEND="chromeos-base/vboot_reference"
