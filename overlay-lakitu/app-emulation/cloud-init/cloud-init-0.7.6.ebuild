# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/cloud-init/cloud-init-0.7.6.ebuild,v 1.3 2015/03/08 23:37:34 pacho Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 eutils multilib systemd

DESCRIPTION="EC2 initialisation magic"
HOMEPAGE="https://launchpad.net/cloud-init"
SRC_URI="https://launchpad.net/${PN}/trunk/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="*"
IUSE="test +gcpnet"

CDEPEND="
	dev-python/cheetah[${PYTHON_USEDEP}]
	dev-python/configobj[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/jsonpatch[${PYTHON_USEDEP}]
	dev-python/oauth[${PYTHON_USEDEP}]
	dev-python/prettytable[${PYTHON_USEDEP}]
	dev-python/pyserial[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		${CDEPEND}
		>=dev-python/httpretty-0.7.1[${PYTHON_USEDEP}]
		dev-python/mocker[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
		~dev-python/pep8-1.5.7[${PYTHON_USEDEP}]
		dev-python/pyflakes[${PYTHON_USEDEP}]
		sys-apps/iproute2
	)
"
RDEPEND="
	${CDEPEND}
	virtual/logger
"

python_prepare_all() {
	use gcpnet && epatch "${FILESDIR}/0.7.6-systemd-configs.patch"
	epatch "${FILESDIR}/0.7.6-stable-uid.patch"
	epatch "${FILESDIR}/0.7.6-resolve-metadata-locally.patch"
	epatch "${FILESDIR}/0.7.6-add-retries-metadata-server.patch"

	# Note: Gentoo places ip in /sbin/ not /bin/
	ebegin 'patching cloudinit/sources/DataSourceOpenNebula.py'
	sed \
		-e '438s/sbin/bin/' \
		-i cloudinit/sources/DataSourceOpenNebula.py
	STATUS=$?
	eend ${STATUS}
	[[ ${STATUS} -gt 0 ]] && die

	# https://bugs.launchpad.net/cloud-init/+bug/1380424
	ebegin 'patching tests/unittests/test_distros/test_netconfig.py'
	sed \
		-e '177s/test_simple_write_freebsd/_&/' \
		-i tests/unittests/test_distros/test_netconfig.py
	STATUS=$?
	eend ${STATUS}
	[[ ${STATUS} -gt 0 ]] && die

	# Note Gentoo installs its own RC files
	ebegin 'patching setup.py'
	sed \
		-e "144 s/'tests'/'tests.*', &/" \
		-e '163,167 d' \
		-i setup.py
	STATUS=$?
	eend ${STATUS}
	[[ ${STATUS} -gt 0 ]] && die

	distutils-r1_python_prepare_all
}

python_test() {
	emake test
}

python_install_all() {
	keepdir /etc/cloud

	distutils-r1_python_install_all

	# Overwrite the default cloud.cfg with our customized version.
	insinto /etc/cloud
	doins "${FILESDIR}"/cloud.cfg

	exeinto /usr/share/cloud
	doexe "${FILESDIR}"/rerun-cloudinit.sh

	systemd_dounit "${FILESDIR}"/var-lib-cloud.mount
	systemd_dounit "${S}"/systemd/cloud-config.service
	systemd_dounit "${S}"/systemd/cloud-config.target
	systemd_dounit "${S}"/systemd/cloud-final.service
	systemd_dounit "${S}"/systemd/cloud-init-local.service
	systemd_dounit "${S}"/systemd/cloud-init.service

	systemd_enable_service local-fs.target var-lib-cloud.mount
	systemd_enable_service multi-user.target cloud-config.service
	systemd_enable_service multi-user.target cloud-final.service
	systemd_enable_service multi-user.target cloud-init-local.service
	systemd_enable_service multi-user.target cloud-init.service
}

pkg_postinst() {
	sed -i -r 's/^(UID_MIN\s+)1000/\15000/' ${ROOT}/etc/login.defs
}
