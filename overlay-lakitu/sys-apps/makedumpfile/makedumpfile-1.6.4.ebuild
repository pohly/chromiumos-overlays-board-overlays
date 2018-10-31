# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=6

SRC_URI="https://sourceforge.net/projects/makedumpfile/files/makedumpfile/${PV}/makedumpfile-${PV}.tar.gz/download -> ${P}.tar.gz"

DESCRIPTION="minimize and compress /proc/vmcore for use with crash"
HOMEPAGE="http://sourceforge.net/projects/makedumpfile/"
LICENSE="GPL-2+"

KEYWORDS="*"

SLOT="0"
IUSE=""

RDEPEND="dev-libs/elfutils"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${P}"


src_compile () {
	# This is a work around for lacking of lelf. See:
	# https://github.com/pratyushanand/makedumpfile/blob/70a9e5edd5b63cf8cce0232d3642fa5397cc0c34/README#L165
	emake LINKTYPE=dynamic
}
