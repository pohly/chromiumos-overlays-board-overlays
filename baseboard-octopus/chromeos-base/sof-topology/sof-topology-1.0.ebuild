# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=5

# Version of the topology package that needs to be downloaded. This should be
# updated when a new topology is required to be used.
TARBALL_NAME="${P}-octopus"

DESCRIPTION="Topology file needed to run SOF."
SRC_URI="gs://chromeos-localmirror/distfiles/${TARBALL_NAME}.tar.bz2"

LICENSE="SOF"
SLOT="0"
KEYWORDS="*"
IUSE=""

S="${WORKDIR}"/"${TARBALL_NAME}"

src_install() {
	insinto /lib/firmware/intel
	doins sof-glk.tplg
	dodoc README
}
