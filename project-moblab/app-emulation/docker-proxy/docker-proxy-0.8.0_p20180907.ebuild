# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
EGO_PN="github.com/docker/libnetwork"

if [[ ${PV} == *9999 ]]; then
	inherit golang-vcs
else
	EGIT_COMMIT="6da50d1978302f04c3e2089e29112ea24812f05b"
	SRC_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="*"
	inherit golang-vcs-snapshot
fi

DESCRIPTION="Docker container networking"
HOMEPAGE="https://github.com/docker/libnetwork"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

S=${WORKDIR}/${P}/src/${EGO_PN}

RDEPEND="!<app-emulation/docker-1.13.0_rc1"

RESTRICT="test" # needs dockerd

src_compile() {
	GOPATH="${WORKDIR}/${P}" go build -o "bin/docker-proxy" ./cmd/proxy || die
}

src_install() {
	dodoc ROADMAP.md README.md CHANGELOG.md
	dobin bin/docker-proxy
}
