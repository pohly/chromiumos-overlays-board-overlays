# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2.

EAPI=6

CROS_WORKON_COMMIT="b22eb3b4179d5b01a8eb142274805823855da8c4"
CROS_WORKON_TREE="b9f4d8d4d97f7a059fabe3b646b3816177a39485"
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_PROJECT="chromiumos/platform/moblab"
CROS_WORKON_LOCALNAME="../platform/moblab"

inherit cros-workon

DESCRIPTION="Install moblab specific upstart init configs"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/moblab/+/master/src/"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="
	!!<chromeos-base/chromeos-bsp-moblab-0.0.1-r49
"

DEPEND="
"

src_install() {
	insinto /etc/init
	doins src/upstart_init/*.conf
}
