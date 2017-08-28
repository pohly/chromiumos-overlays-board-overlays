# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit toolchain-funcs versionator

DESCRIPTION="Userspace utils and init scripts for the AppArmor application security system"
HOMEPAGE="http://apparmor.net/"
SRC_URI="https://launchpad.net/${PN}/$(get_version_component_range 1-2)/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE="doc"

RDEPEND="~sys-libs/libapparmor-${PV}"
DEPEND="${RDEPEND}
	dev-lang/perl
	sys-devel/bison
	sys-devel/flex
	doc? ( dev-tex/latex2html )
"

S=${WORKDIR}/apparmor-${PV}/parser

src_prepare() {
	default
	# apparmor_parser uses C++ exceptions, so whitelist them.
	cros_enable_cxx_exceptions
	# remove warning about missing file that controls features
	# we don't currently support
	sed -e "/installation problem/ctrue" -i rc.apparmor.functions || die
	epatch "${FILESDIR}/${PN}-2.10-dynamic-link.patch"
	epatch "${FILESDIR}/${PN}-2.10-makefile.patch"
	epatch "${FILESDIR}/${PN}-2.10-libcxx.patch"
}

src_compile()  {
	emake CC="$(tc-getCC)" CXX="$(tc-getCXX)" USE_SYSTEM=1 \
		LD="$(tc-getLD)" EXTRA_LDFLAGS="-L${ROOT}/usr/$(get_libdir)" \
		INCLUDEDIR="${ROOT}/usr/include" \
		arch
}

src_install() {
	emake DESTDIR="${D}" USE_SYSTEM=1 \
		CC="$(tc-getCC)" CXX="$(tc-getCXX)" \
		install-arch

	dodir /etc/apparmor.d/disable
}
