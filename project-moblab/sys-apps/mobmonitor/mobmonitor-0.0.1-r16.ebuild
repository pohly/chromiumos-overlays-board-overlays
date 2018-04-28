# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2.

EAPI=6

CROS_WORKON_COMMIT="17e5e59b0bc7cd7ad36b0e3ddcaf24e7855d65f6"
CROS_WORKON_TREE="50ba56ef1b8c28dc0f2459bd124f8cd3364c380a"
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_PROJECT="chromiumos/platform/moblab"
CROS_WORKON_LOCALNAME="../platform/moblab"

inherit cros-workon

DESCRIPTION="MobLab sys-app that monitors system essential services"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/moblab/+/master/src/mobmonitor/"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND=""

DEPEND="
	${RDEPEND}
"
MOBMONITOR_BASE="/usr/local/moblab/mobmonitor"

src_install() {
	insinto "${MOBMONITOR_BASE}"
	doins -r src/mobmonitor/*
}
