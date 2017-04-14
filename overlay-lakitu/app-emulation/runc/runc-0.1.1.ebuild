# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils multilib

DESCRIPTION="runc container cli tools"
HOMEPAGE="http://runc.io"

GITHUB_URI="github.com/opencontainers/runc"

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="git://${GITHUB_URI}.git"
	inherit git-r3
else
	SRC_URI="https://${GITHUB_URI}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="-* amd64"
fi

LICENSE="Apache-2.0"
SLOT="0"
IUSE="+seccomp apparmor"

DEPEND="
	>=dev-lang/go-1.4:=
	apparmor? (
		sys-libs/libapparmor[static-libs]
	)
"
RDEPEND="seccomp? ( sys-libs/libseccomp )"

src_prepare() {
	epatch "${FILESDIR}/0.1.0-use-GO-cross-compiler.patch"
	epatch "${FILESDIR}/0.1.1-eliminate-redundant-parsing-of-mountinfo.patch"
	epatch "${FILESDIR}/0.1.1-non-dumpable.patch"
}

src_compile() {
	# Taken from app-emulation/docker-1.7.0-r1
	export CGO_CFLAGS="-I${ROOT}/usr/include"
	export CGO_LDFLAGS="-L${ROOT}/usr/$(get_libdir)"

	# Setup GOPATH so things build
	rm -rf .gopath
	mkdir -p .gopath/src/"$(dirname "${GITHUB_URI}")"
	ln -sf ../../../.. .gopath/src/"${GITHUB_URI}"
	export GOPATH="${PWD}/.gopath:${PWD}/vendor"

	# build up optional flags
	local options=(
		$(usex seccomp "seccomp")
		$(usex apparmor "apparmor")
	)

	export GOTRACEBACK="crash"
	export GO=$(tc-getGO)
	# Prepare a string of optional flags to pass via BUILDTAGS.
	local buildtags="${options[@]}"
	emake BUILDTAGS="${buildtags}"
}

src_install() {
	dobin runc
}
