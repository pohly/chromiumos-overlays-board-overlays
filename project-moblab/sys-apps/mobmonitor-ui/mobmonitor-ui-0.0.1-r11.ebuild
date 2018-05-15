# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2.

EAPI=6

CROS_WORKON_COMMIT="d0c054d15e6c620960bed85c4301f324f7cbe054"
CROS_WORKON_TREE="16ccd1a00effd8ba9bf2403b920d2985bcc1337c"
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_PROJECT="chromiumos/platform/moblab"
CROS_WORKON_LOCALNAME="../platform/moblab"

inherit cros-workon

DESCRIPTION="Build Mobmonitor's Angular frontend"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/moblab/+/master/src/mobmonitor-ui/"

# download all javascript build time dependencies
# such as angular, angular cli, typescript, material
# these are normally installed by `npm install` but
# this method of prepackaging and placing in gs is more
# ebuild friendly
BASE_SRC_URI="gs://chromeos-localmirror/distfiles"
SRC_URI="${BASE_SRC_URI}/mobmonitor-ui-node_modules-0.0.1.tar.gz"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND=""

DEPEND="
	${RDEPEND}
	net-libs/nodejs
"
APP_BASE="/etc/moblab/mobmonitor/static"

src_unpack() {
	cros-workon_src_unpack
	default
}

src_compile() {
	cp -r "${S}/src/mobmonitor-ui" "${WORKDIR}/src"
	mv "${WORKDIR}/node_modules" "${WORKDIR}/src/node_modules"
	cd "${WORKDIR}/src"
	node ./node_modules/.bin/ng build --prod \
			--extract-licenses=false --aot=false || die
}

src_install() {
	insinto "${APP_BASE}"
	doins -r "${WORKDIR}"/src/dist/*
}
