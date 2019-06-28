# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit appid

DESCRIPTION="Jerry bsp (meta package to pull in driver/tool deps)"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="-* arm"
IUSE="jerry-kernelnext"

DEPEND="!<chromeos-base/chromeos-bsp-jerry-private-0.0.1"
RDEPEND=""

S=${WORKDIR}

src_install() {
	if use jerry-kernelnext; then
		doappid "{9E534804-99C9-11E9-A1CE-F3B60FAEC18C}" "CHROMEBOOK"
	else
		doappid "{87C6D674-9385-6143-BE67-8B5E3064E89D}" "CHROMEBOOK" # veyron-jerry
	fi
}
