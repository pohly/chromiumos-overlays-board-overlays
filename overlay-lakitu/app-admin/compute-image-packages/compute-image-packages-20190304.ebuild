# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 eutils systemd

SRC_URI="https://github.com/GoogleCloudPlatform/compute-image-packages/archive/${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/${P}/packages/python-google-compute-engine"

DESCRIPTION="Linux Guest Environment for Google Compute Engine"
HOMEPAGE="https://github.com/GoogleCloudPlatform/compute-image-packages"
LICENSE="Apache-2.0"

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
	app-admin/oslogin
"

python_prepare_all() {
	# ${S} is set to '${WORKDIR}/${P}/packages/python-google-compute-engine'
	# i.e where setup.py is located as distutils-r1 expect setup.py to be
	# at ${S}. As we have patches which are outside
	# packages/python-google-compute-engine, we cd two level up.
	pushd "${S}"/../../
	epatch "${FILESDIR}/20190304-homedir-uid-fix.patch"
	epatch "${FILESDIR}/20190304-no-boto.patch"
	epatch "${FILESDIR}/20190304-do-not-block-sshd-for-google.service.patch"
	popd
	distutils-r1_python_prepare_all
}

python_install() {
	distutils-r1_python_install \
		--install-scripts=/usr/bin \
		--install-data=/usr/share/doc/google-compute-engine
}

python_install_all() {
	distutils-r1_python_install_all

	local init_path="${S}/../google-compute-engine/src/lib/systemd/system"
	local service
	for service in "${init_path}"/*.service; do
		systemd_dounit "${service}"
		systemd_enable_service multi-user.target "${service##*/}"
	done

	systemd_dounit "${FILESDIR}/var-lib-google.mount"
	systemd_dounit "${FILESDIR}/var-lib-google-remount.service"
	systemd_enable_service local-fs.target var-lib-google.mount

	# Backports the get-metadata-value script from older version of this
	# package (1.3.3).
	exeinto /usr/share/google/
	newexe ${FILESDIR}/1.3.3-get_metadata_value get_metadata_value

	# Install distro specific default configuration.
	insinto /etc/default/
	newins "${FILESDIR}/20190304-instance_configs.cfg.distro" instance_configs.cfg.distro
}
