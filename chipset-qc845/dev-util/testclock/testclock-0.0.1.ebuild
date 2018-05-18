# Copyright (c) 2014 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Utils for measuring SDM845 clock frequencies via /dev/mem"
HOMEPAGE="http://chromium.org"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="-* arm64 arm"
IUSE=""

DEPEND="dev-python/setuptools"
RDEPEND="dev-util/mem"

src_unpack() {
	S=${WORKDIR}
	cp -r "${FILESDIR}/"* "${S}" || die
}
