# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=5

DESCRIPTION="GCE Containers Startup"
HOMEPAGE="https://github.com/GoogleCloudPlatform/konlet"
SRC_URI="https://github.com/GoogleCloudPlatform/konlet/archive/v.${PV}.tar.gz"
RESTRICT="mirror"

inherit eutils systemd

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-v.${PV}"

src_install() {
	exeinto /usr/share/gce-containers
	doexe "${S}"/scripts/konlet-startup

	systemd_dounit "${S}"/scripts/konlet-startup.service
	systemd_enable_service multi-user.target konlet-startup.service
}
