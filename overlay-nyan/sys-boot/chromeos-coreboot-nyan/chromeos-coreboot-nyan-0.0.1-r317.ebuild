# Copyright (c) 2013 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4
CROS_WORKON_COMMIT=("6d609e367b92a36b0442fd427ebd87018a7733f7" "4d290ba6bd3bd7014d01720d79db8de50964d760")
CROS_WORKON_TREE=("b72841e15ad5630d06fa15e4d0b63a23ed6fd687" "bfc52c4e96b2a565e511d47daefc08f27c9eb2be")
CROS_WORKON_PROJECT=("chromiumos/third_party/coreboot" "chromiumos/platform/vboot_reference")
CROS_WORKON_LOCALNAME=("coreboot" "../platform/vboot_reference")
CROS_WORKON_DESTDIR=("${S}" "${S}/vboot_reference")

inherit cros-board cros-workon cros-coreboot

KEYWORDS="arm"

DEPEND="dev-embedded/cbootimage"

RDEPEND="chromeos-base/vboot_reference"
