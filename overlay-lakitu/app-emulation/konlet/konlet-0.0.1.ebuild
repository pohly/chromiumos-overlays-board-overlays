# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=5

DESCRIPTION="GCE Containers Startup"
HOMEPAGE="https://github.com/GoogleCloudPlatform/konlet"
# For now, we use the Git commit ID to identify the version.
# This is 0.8 .
GIT_COMMIT_ID="2b053ba32c1c7c4a539a035c381e44bdcbc44871"
SRC_URI="https://github.com/GoogleCloudPlatform/konlet/archive/${GIT_COMMIT_ID}.tar.gz -> ${P}-${GIT_COMMIT_ID}.tar.gz"
RESTRICT="mirror"

inherit eutils systemd

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${GIT_COMMIT_ID}"

src_prepare() {
	epatch "${FILESDIR}"/konlet-0.0.1-script-fixes.patch
}

src_install() {
	exeinto /usr/share/gce-containers
	doexe "${S}"/scripts/konlet-startup

	systemd_dounit "${S}"/scripts/konlet-startup.service
	systemd_enable_service multi-user.target konlet-startup.service
}
