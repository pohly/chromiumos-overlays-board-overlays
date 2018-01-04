# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
EGO_PN="github.com/containerd/${PN}"

inherit eutils toolchain-funcs

if [[ ${PV} == *9999 ]]; then
	inherit golang-vcs
else
	MY_PV="${PV/_rc/-rc.}"
	EGIT_COMMIT="v${MY_PV}"
	CONTAINERD_COMMIT="89623f2"
	SRC_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="*"
	inherit golang-vcs-snapshot
fi

DESCRIPTION="A daemon to control runC"
HOMEPAGE="https://containerd.tools"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="+btrfs hardened"

DEPEND="btrfs? ( sys-fs/btrfs-progs )"
RDEPEND="|| ( >=app-emulation/docker-runc-1.0.0_rc4
	>=app-emulation/runc-1.0.0_rc4 )
	sys-libs/libseccomp"

S=${WORKDIR}/${P}/src/${EGO_PN}

src_prepare() {
	epatch "${FILESDIR}/1.0.0-use-GO-cross-compiler.patch"
	epatch "${FILESDIR}/1.0.0-fix-clang-compile-error.patch"
	default
	# lakitu: Since EAPI 6, the default src_prepare() runs 'eapply_user'.
	# Because we use EAPI 5, we explicitly call 'epatch_user' here.
	epatch_user
	if [[ ${PV} != *9999* ]]; then
		sed -i -e "s/git describe --match.*$/echo ${PV})/"\
			-e "s/git rev-parse HEAD.*$/echo $CONTAINERD_COMMIT)/"\
			-e "s/-s -w//" \
			Makefile || die
	fi
}

src_compile() {
	local options=( $(usex btrfs "" "no_btrfs") )
	export GOPATH="${WORKDIR}/${P}" # ${PWD}/vendor
	export GOTRACEBACK="crash"
	export GO=$(tc-getGO)
	LDFLAGS=$(usex hardened '-extldflags -fno-PIC' '') emake BUILDTAGS="${options[@]}"
}

src_install() {
	dobin bin/containerd{-shim,-stress,} bin/ctr
}
