# Copyright (c) 2013 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4
CROS_WORKON_COMMIT=("996200507b8f0df36916438ff24d1783ef9a4648" "4d290ba6bd3bd7014d01720d79db8de50964d760")
CROS_WORKON_TREE=("3dca3b90d7fe863e4749cfd1092472c998147053" "bfc52c4e96b2a565e511d47daefc08f27c9eb2be")
CROS_WORKON_PROJECT=("chromiumos/third_party/coreboot" "chromiumos/platform/vboot_reference")
CROS_WORKON_LOCALNAME=("coreboot" "../platform/vboot_reference")
CROS_WORKON_DESTDIR=("${S}" "${S}/vboot_reference")

inherit cros-board cros-workon cros-coreboot

KEYWORDS="arm"

DEPEND="dev-embedded/cbootimage"

RDEPEND="chromeos-base/vboot_reference"
