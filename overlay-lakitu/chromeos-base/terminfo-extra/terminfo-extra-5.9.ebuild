# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

HOMEPAGE="https://www.gnu.org/software/ncurses/ http://dickey.his.com/ncurses/"
SRC_URI="mirror://gnu/ncurses/ncurses-${PV}.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="*"

DEPEND="sys-libs/ncurses[minimal]"
RDEPEND="${DEPEND}"

S=${WORKDIR}/ncurses-${PV}

TERMINFO_EXTRAS="xterm-256color"

src_configure() {
  :
}

src_compile() {
  tic -x -o terminfo -e "${TERMINFO_EXTRAS}" misc/terminfo.src || die
}

src_install() {
  insinto /usr/share
  doins -r terminfo
}
