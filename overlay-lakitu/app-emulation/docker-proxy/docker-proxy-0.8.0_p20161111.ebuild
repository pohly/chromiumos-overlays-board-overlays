# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils golang-base

EGO_PN="github.com/docker/libnetwork"

if [[ ${PV} == *9999 ]]; then
	inherit golang-vcs
else
	EGIT_COMMIT="57be722e077059d1ee0539be31743a3642ccbeb3"
	SRC_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="*"
	inherit golang-vcs-snapshot
fi

DESCRIPTION="Docker container networking"
HOMEPAGE="http://github.com/docker/libnetwork"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

S=${WORKDIR}/${P}/src/${EGO_PN}

RDEPEND="!<app-emulation/docker-1.13.0_rc1"

src_compile() {
	export GOTRACEBACK="crash"
	export GO=$(tc-getGO)
	GOPATH="${WORKDIR}/${P}:$(get_golibdir_gopath)" ${GO} build -o "bin/docker-proxy" ./cmd/proxy || die
}

src_install() {
	dodoc ROADMAP.md README.md CHANGELOG.md
	dobin bin/docker-proxy
}
