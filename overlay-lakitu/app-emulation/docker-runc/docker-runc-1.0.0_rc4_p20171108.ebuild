# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils toolchain-funcs

EGO_PN="github.com/opencontainers/${PN/docker-}"

if [[ ${PV} == *9999 ]]; then
	inherit golang-vcs
else
	MY_PV="${PV/_/-}"
	EGIT_COMMIT="b2567b37d7b75eb4cf325b77297b140ea686ce8f"
	RUNC_COMMIT="b2567b3" # Change this when you update the ebuild
	SRC_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="*"
	inherit golang-vcs-snapshot
fi

DESCRIPTION="runc container cli tools (docker fork)"
HOMEPAGE="http://runc.io"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="+ambient apparmor hardened +seccomp"

RDEPEND="
	apparmor? ( sys-libs/libapparmor )
	seccomp? ( sys-libs/libseccomp )
	!app-emulation/runc
"

S=${WORKDIR}/${P}/src/${EGO_PN}

RESTRICT="test"

src_prepare() {
	epatch "${FILESDIR}/1.0.0_rc4_p20171108-use-GO-cross-compiler.patch"
	default
	# lakitu: Since EAPI 6, the default src_prepare() runs 'eapply_user'.
	# Because we use EAPI 5, we explicitly call 'epatch_user' here.
	epatch_user
	sed -i -e "s/git rev-parse.*\$/echo gentoo)/" -e "/COMMIT :=/d" -e "/COMMIT_NO :=/d" Makefile || die
}

src_compile() {
	# Taken from app-emulation/docker-1.7.0-r1
	export CGO_CFLAGS="-I${ROOT}/usr/include"
	export CGO_LDFLAGS="$(usex hardened '-fno-PIC ' '')
		-L${ROOT}/usr/$(get_libdir)"

	export GOTRACEBACK="crash"
	export GO=$(tc-getGO)
	# build up optional flags
	local options=(
		$(usex ambient 'ambient' '')
		$(usex apparmor 'apparmor' '')
		$(usex seccomp 'seccomp' '')
	)

	GOPATH="${WORKDIR}/${P}" emake BUILDTAGS="${options[*]}" \
		COMMIT="${RUNC_COMMIT}"
}

src_install() {
	dobin runc
}
