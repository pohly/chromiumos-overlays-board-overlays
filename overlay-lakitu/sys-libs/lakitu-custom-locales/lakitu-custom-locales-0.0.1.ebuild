# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=6

#inherit eutils

DESCRIPTION="Package that installs Lakitu specific locales"
LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
S="${WORKDIR}"

src_install() {
	# localedef installs locale-archive here and fails if it doesn't exist.
	dodir /usr/lib64/locale

	localedef --prefix="${D}" -f UTF-8 -i "${FILESDIR}"/C C.UTF-8 || die
}
