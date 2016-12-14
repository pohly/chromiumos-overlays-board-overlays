# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=4
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 systemd

SRC_URI="https://github.com/GoogleCloudPlatform/compute-image-packages/archive/${PV}.tar.gz -> ${P}.tar.gz"

DESCRIPTION="A Python package for Linux daemons, scripts, and libraries."
HOMEPAGE="http://github.com/GoogleCloudPlatform/compute-image-packages/tree/master"
LICENSE="BSD-Google"

KEYWORDS="*"

SLOT="0"
IUSE=""

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
"
RDEPEND="
	sys-apps/iproute2
	!app-admin/google-daemon
	!app-admin/google-startup-scripts
"

python_prepare_all() {
	epatch "${FILESDIR}/metadata-watcher-no-infinite-loop.patch"
	epatch "${FILESDIR}/execute-startup-scripts-from-var-lib-google.patch"
	epatch "${FILESDIR}/set-ethtool-to-usr-sbin.patch"
	epatch "${FILESDIR}/catch-read-only-root-fs.patch"
	epatch "${FILESDIR}/homedir-uid-fix.patch"
	epatch "${FILESDIR}/do-not-block-sshd-for-google.service.patch"
	epatch "${FILESDIR}/no-boto.patch"
	distutils-r1_python_prepare_all
}

python_install() {
	distutils-r1_python_install \
		--install-scripts=/usr/bin \
		--install-data=/usr/share/doc/google-compute-engine
}

python_install_all() {
	distutils-r1_python_install_all

	local init_path="${S}/google_compute_engine_init/systemd"
	local service
	for service in "${init_path}"/*.service; do
		systemd_dounit "${service}"
		systemd_enable_service multi-user.target "${service##*/}"
	done

	systemd_dounit "${FILESDIR}/var-lib-google-remount.service"
	systemd_enable_service local-fs.target var-lib-google-remount.service

	# Install the helper script.
	exeinto /usr/share/google/
	newexe ${FILESDIR}/get_metadata_value.py get_metadata_value
}
