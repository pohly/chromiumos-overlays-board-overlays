# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit cros-binary

DESCRIPTION="Apollo Lake hotword DSP firmware and language models"
LICENSE="Google-TOS"
SLOT="0"

KEYWORDS="-* x86 amd64"

S=${WORKDIR}

SRC_URI="gs://chromeos-localmirror/distfiles/${P}.tbz2"

src_install() {
	insinto /
	doins -r *
}