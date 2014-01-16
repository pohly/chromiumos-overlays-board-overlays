# Copyright (c) 2013 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4
CROS_WORKON_COMMIT=("0bc64173b3b93ad84054d9719cede8ac94f69f86" "04171532583052935121a3e33550cc39ef2625ec")
CROS_WORKON_TREE=("2964be81aa16f99a9d50b5e044854ec71f2512e9" "9e8b9350d8c2e16a9114150a552e97604340cb49")
CROS_WORKON_PROJECT=("chromiumos/third_party/coreboot" "chromiumos/platform/vboot_reference")
CROS_WORKON_LOCALNAME=("coreboot" "../platform/vboot_reference")
CROS_WORKON_DESTDIR=("${S}" "${S}/vboot_reference")

inherit cros-board cros-workon cros-coreboot

KEYWORDS="arm"

DEPEND="dev-embedded/cbootimage"

RDEPEND="chromeos-base/vboot_reference"
