# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2.

EAPI=6

CROS_WORKON_COMMIT="12ca0e26119f1f784ec93dfd13425570aee621f4"
CROS_WORKON_TREE="44df2f2aa4325c1f44ba32fc939492b802d46fd1"
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
