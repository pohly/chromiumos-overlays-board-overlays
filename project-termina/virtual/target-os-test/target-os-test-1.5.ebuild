# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="List of packages that make up the test OS image;
by default, we build a Chromium OS test image.
Note: test images are a superset of dev images."
HOMEPAGE="http://dev.chromium.org/"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="virtual/target-termina-os-test"
