# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

SRC_URI="https://github.com/sosreport/sos/archive/${PV}.tar.gz -> ${P}.tar.gz"

DESCRIPTION="An extensible, portable, support data collection tool."
HOMEPAGE="https://github.com/sosreport/sos"
LICENSE="GPL-2"

KEYWORDS="*"

SLOT="0"
IUSE=""

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
"
RDEPEND="
	dev-python/futures[${PYTHON_USEDEP}]
"

S="${WORKDIR}/sos-${PV}"

PATCHES=(
	"${FILESDIR}/0001-policies-add-COS-policy.patch"
	"${FILESDIR}/0002-plugins-mark-9-plugins-as-supported-on-COS.patch"
)

python_install() {
	distutils-r1_python_install

	# Provide default config file.
	insinto /etc/
	doins "${FILESDIR}"/sos.conf
}
