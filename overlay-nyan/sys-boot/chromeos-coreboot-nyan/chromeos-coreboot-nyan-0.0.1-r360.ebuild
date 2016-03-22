# Copyright (c) 2013 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4
CROS_WORKON_COMMIT=("519ff11e835ec46d502758ff952572853e613f21" "b68a08bd257ad25c3be3ddb2c1c03b93aad68bb9")
CROS_WORKON_TREE=("2c92a9c5e43308eaf0f2c10235673060632dd3b9" "6299aa2af567b6554298d781257fb36eb728894a")
CROS_WORKON_PROJECT=("chromiumos/third_party/coreboot" "chromiumos/platform/vboot_reference")
CROS_WORKON_LOCALNAME=("coreboot" "../platform/vboot_reference")
CROS_WORKON_DESTDIR=("${S}" "${S}/vboot_reference")

inherit cros-board cros-workon cros-coreboot

KEYWORDS="arm"

DEPEND="dev-embedded/cbootimage"

RDEPEND="chromeos-base/vboot_reference"
