# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=5

inherit eutils

DESCRIPTION="Package that installs Lakitu specific locales"
LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
S="${WORKDIR}"

GLIBC_P="glibc-2.23"

# Taken from sys-libs/glibc
upstream_uris() {
	echo mirror://gnu/glibc/$1 ftp://sourceware.org/pub/glibc/{releases,snapshots}/$1 mirror://gentoo/$1
}

SRC_URI=$( upstream_uris ${GLIBC_P}.tar.xz )

src_prepare() {
	cd "${S}/${GLIBC_P}"
	epatch "${FILESDIR}/${GLIBC_P}-c-utf8-locale.patch"
}

src_install() {
	# localedef installs locale-archive here and fails if it doesn't exist.
	dodir /usr/lib64/locale

	# Only install C.UTF-8 for now.
	I18NPATH="${S}/${GLIBC_P}/localedata/" localedef --prefix="${D}" -f UTF-8 -i C C.UTF-8
}
