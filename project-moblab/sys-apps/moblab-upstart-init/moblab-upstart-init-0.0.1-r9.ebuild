# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2.

EAPI=6

CROS_WORKON_COMMIT="8b0d46e2e38a4f5ad917747a42d7297182ea536a"
CROS_WORKON_TREE="162cac8e1aa92f537a23cd7954cf86e0bc521778"
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
