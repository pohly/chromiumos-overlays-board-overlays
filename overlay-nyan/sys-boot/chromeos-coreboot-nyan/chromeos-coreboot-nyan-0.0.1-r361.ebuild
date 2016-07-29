# Copyright (c) 2013 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4
CROS_WORKON_COMMIT=("519ff11e835ec46d502758ff952572853e613f21" "b1d75add014b7383e00961156ce51749e6507465")
CROS_WORKON_TREE=("2c92a9c5e43308eaf0f2c10235673060632dd3b9" "2d6692b7905ac6f6061a7385c2c9a8dcea49758f")
CROS_WORKON_PROJECT=("chromiumos/third_party/coreboot" "chromiumos/platform/vboot_reference")
CROS_WORKON_LOCALNAME=("coreboot" "../platform/vboot_reference")
CROS_WORKON_DESTDIR=("${S}" "${S}/vboot_reference")

inherit cros-board cros-workon cros-coreboot

KEYWORDS="arm"

DEPEND="dev-embedded/cbootimage"

RDEPEND="chromeos-base/vboot_reference"
