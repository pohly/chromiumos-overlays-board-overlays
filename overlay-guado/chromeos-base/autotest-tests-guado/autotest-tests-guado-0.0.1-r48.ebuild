# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI="5"
CROS_WORKON_COMMIT="5f23fe94f80c60e1fb11e48e2703555de17413c3"
CROS_WORKON_TREE="d007abc6ec3f16c008189714c98df15ef1534e5c"
CROS_WORKON_PROJECT="chromiumos/third_party/autotest"
CROS_WORKON_LOCALNAME=../third_party/autotest
CROS_WORKON_SUBDIR=files

inherit cros-workon autotest

DESCRIPTION="Autotest server tests specific to Guado board"
HOMEPAGE="http://www.chromium.org/"
LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

IUSE="+autotest"

SERVER_IUSE_TESTS="
	+tests_enterprise_CFM_HuddlyUpdater
"

IUSE_TESTS="${IUSE_TESTS}
	${SERVER_IUSE_TESTS}
"

IUSE="${IUSE} ${IUSE_TESTS}"

AUTOTEST_FILE_MASK="*.a *.tar.bz2 *.tbz2 *.tgz *.tar.gz"

src_configure() {
	cros-workon_src_configure
}
