# Copyright (c) 2013 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4
CROS_WORKON_COMMIT=("6405a2d162a57b659ed84fddb6fc15c66316309e" "462a3cadc717201345bd8f74cb7018cd4e60c3e5")
CROS_WORKON_TREE=("abd5ad3480864b2f6918063b82183cbb084b200f" "0ca64560b0b658fa4553ebe7430a13942312f133")
CROS_WORKON_PROJECT=("chromiumos/third_party/coreboot" "chromiumos/platform/vboot_reference")
CROS_WORKON_LOCALNAME=("coreboot" "../platform/vboot_reference")
CROS_WORKON_DESTDIR=("${S}" "${S}/vboot_reference")

inherit cros-board cros-workon cros-coreboot

KEYWORDS="arm"

DEPEND="dev-embedded/cbootimage"

RDEPEND="chromeos-base/vboot_reference"
