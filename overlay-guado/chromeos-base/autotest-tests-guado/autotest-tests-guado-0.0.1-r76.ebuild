# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI="5"
CROS_WORKON_COMMIT="bf336904155b5613a4764f91a9024eec47fce1a7"
CROS_WORKON_TREE="c0561c659dc62a973491680df0ea6dbd68270461"
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
