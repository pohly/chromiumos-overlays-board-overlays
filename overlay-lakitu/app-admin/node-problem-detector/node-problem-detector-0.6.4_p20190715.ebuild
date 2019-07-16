# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=6

inherit eutils golang-vcs-snapshot toolchain-funcs systemd

EGO_PN="k8s.io/node-problem-detector"
DESCRIPTION="node-problem-detector"
HOMEPAGE="https://github.com/kubernetes/node-problem-detector"

# NPD is being activelly developed to suit lakitu's use cases. To allow us
# picking up latest version of NPD without cutting NPD releases too frequently,
# we will choose NPD code based on the commit hash.
# TODO(xueweiz): remove EGIT_COMMIT and use officially released version before
# enabling NPD in overlay-lakitu.
EGIT_COMMIT="b8ce6360d93d61eacf9f7442d344f8fb263a38af"
SRC_URI="https://github.com/kubernetes/node-problem-detector/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"

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

	emake VERSION="${PV}-${EGIT_COMMIT}" bin/node-problem-detector
}

src_install() {
	insinto /etc/node_problem_detector
	doins config/system-stats-monitor.json
	doins config/docker-monitor.json
	doins config/kernel-monitor.json

	dosbin bin/node-problem-detector

	systemd_dounit "${FILESDIR}"/node-problem-detector.service
	systemd_enable_service multi-user.target node-problem-detector.service
}
