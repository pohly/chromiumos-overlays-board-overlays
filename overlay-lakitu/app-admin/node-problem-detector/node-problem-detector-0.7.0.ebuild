# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=6

inherit eutils golang-vcs-snapshot toolchain-funcs systemd

EGO_PN="k8s.io/node-problem-detector"
DESCRIPTION="node-problem-detector"
HOMEPAGE="https://github.com/kubernetes/node-problem-detector"

SRC_URI="https://github.com/kubernetes/node-problem-detector/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"
IUSE=""

DEPEND="
	sys-apps/systemd
"
RDEPEND="
	sys-apps/systemd
"

PATCHES=(
	"${FILESDIR}"/Use-specified-Go-compiler-for-cross-compilation.patch
)

S="${WORKDIR}/${P}/src/${EGO_PN}"

src_compile() {
	export GOPATH="${WORKDIR}/${P}"

	GO=$(tc-getGO)
	export GO
	echo "GO compiler: '${GO}'"

	emake VERSION="${PV}" bin/node-problem-detector
}

src_install() {
	insinto /etc/node_problem_detector
	doins "${FILESDIR}"/system-stats-monitor.json
	doins "${FILESDIR}"/docker-monitor.json
	doins "${FILESDIR}"/kernel-monitor.json

	dosbin bin/node-problem-detector

	systemd_dounit "${FILESDIR}"/node-problem-detector.service
	systemd_enable_service multi-user.target node-problem-detector.service
}
