# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=5

DESCRIPTION="CoreOS Toolbox Utility"
HOMEPAGE="https://github.com/coreos/toolbox"
EGIT_REPO_URI="https://chromium.googlesource.com/external/github.com/coreos/toolbox.git"
EGIT_COMMIT="a2767a0013c409a2381f7cdd4e31000b5fcded7e"

inherit eutils git-2 systemd

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/0.0.1-load-docker-image-from-tarball.patch
}

src_install() {
	dobin "${S}"/toolbox
	insinto /etc/default
	newins "${FILESDIR}"/etc.default.toolbox toolbox

	systemd_dounit "${FILESDIR}"/var-lib-toolbox.mount
	systemd_dounit "${FILESDIR}"/var-lib-toolbox-remount.service
	systemd_enable_service local-fs.target var-lib-toolbox.mount
}
