# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=5

inherit pam flag-o-matic

DESCRIPTION="Google Compute Engine OS Login libraries, applications and configurations."
HOMEPAGE="https://github.com/GoogleCloudPlatform/compute-image-packages/tree/master/google_compute_engine_oslogin"

# Release tag of compute-image-packages.
CIP_PV="20180129"
SRC_URI="https://github.com/GoogleCloudPlatform/compute-image-packages/archive/${CIP_PV}.tar.gz -> compute-image-packages-${CIP_PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"

DEPEND="
	net-misc/curl
	dev-libs/json-c
	sys-libs/pam
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/compute-image-packages-${CIP_PV}/google_compute_engine_oslogin"

src_prepare() {
	epatch "${FILESDIR}/${P}-makefile.patch"
}

src_compile() {
	emake JSON_INCLUDE_PATH="${SYSROOT}/usr/include/json-c"
}

src_install() {
	emake DESTDIR="${D}" NSS_INSTALL_PATH=$(get_libdir) \
		PAM_INSTALL_PATH=$(getpam_mod_dir) install
	dosym libnss_google-compute-engine-oslogin-"${PV}".so \
		"$(get_libdir)"/libnss_oslogin.so.2
}
