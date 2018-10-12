# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2.

EAPI=6

CROS_WORKON_COMMIT="391f45919e432b60c7d5696b99db8bf80fc5d6e9"
CROS_WORKON_TREE="accf971d4b52ddb2156f31680024cdc3522b3982"
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
MOBMONITOR_BASE="/etc/moblab/mobmonitor"

src_install() {
	insinto "${MOBMONITOR_BASE}"
	doins -r src/mobmonitor/*
}
