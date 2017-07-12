# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit cros-binary toolchain-funcs

DESCRIPTION="Intel 3a libraries"
#SRC_URI="TBD"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="-* amd64"

S="${WORKDIR}"

src_install() {
	# TBD
	true
}

