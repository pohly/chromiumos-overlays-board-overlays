# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2.

EAPI=6

CROS_WORKON_COMMIT="1bc43c4a8e4ada9c9a08722ce708acb303ca4e23"
CROS_WORKON_TREE="b6f3696037866f3714059ba2a0f44e17b4734b6f"
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_PROJECT="chromiumos/platform/moblab"
CROS_WORKON_LOCALNAME="../platform/moblab"

inherit cros-workon

DESCRIPTION="MobLab sys-app that monitors system essential services"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/moblab/+/master/src/mobmonitor/"

BASE_SRC_URI="gs://chromeos-localmirror/distfiles"
SRC_URI="${BASE_SRC_URI}/jquery-2.1.3.tar.gz
${BASE_SRC_URI}/jquery-ui-1.11.4.custom.zip
${BASE_SRC_URI}/handlebars.min-v3.0.3.js
"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND=""

DEPEND="
	${RDEPEND}
"
MOBMONITOR_BASE="/usr/local/moblab/mobmonitor"

src_unpack() {
	cros-workon_src_unpack
	default
}

src_install() {
	insinto "${MOBMONITOR_BASE}"
	doins -r src/mobmonitor/*

	insinto "${MOBMONITOR_BASE}/static/third_party/jquery/2.1.3"
	doins "${WORKDIR}/jquery-2.1.3/dist/jquery.min.js"

	insinto "${MOBMONITOR_BASE}/static/third_party/jquery-ui/1.11.4"
	local jquery_ui_dir="${WORKDIR}/jquery-ui-1.11.4.custom"
	doins "${jquery_ui_dir}/jquery-ui.min.js"
	doins "${jquery_ui_dir}/jquery-ui.css"

	insinto "${MOBMONITOR_BASE}/static/third_party/handlebars.js/3.0.3"
	doins "${DISTDIR}/handlebars.min-v3.0.3.js"
}
