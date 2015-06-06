# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="4"

inherit user

DESCRIPTION="Ebuild which pulls in any necessary ebuilds as dependencies or portage actions"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND=""

# Direct runtime dependencies.
RDEPEND="${RDEPEND}
	dev-vcs/git
	dev-vcs/repo
"

# Pull in dependencies for cbuildbot, buildbot.
RDEPEND="${RDEPEND}
	chromeos-base/cbuildbot-deps
"

DEPEND=""

S=${WORKDIR}

pkg_setup() {
	enewgroup mobbuild
	enewuser mobbuild
}

src_install(){
	insinto /etc/init
	doins "${FILESDIR}"/init/*.conf

	insinto /etc/sudoers.d
	echo "mobbuild ALL=NOPASSWD: ALL" > mobbuild-all
	insopts -m600
	doins mobbuild-all
}
