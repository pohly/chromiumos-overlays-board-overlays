# Copyright (c) 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="4"

DESCRIPTION="Generic ebuild that satisifies virtual/chromeos-test-testauthkeys.
This is a direct dependency of chromeos-base/chromeos-test-testauthkeys, but is
expected to be overridden in an overlay for some specialized board."
HOMEPAGE="http://www.chromium.org/"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

S="${WORKDIR}"

RDEPEND="chromeos-base/chromeos-test-testauthkeys"
