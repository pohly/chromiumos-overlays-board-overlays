# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

# This package includes version of cgpt from CoreOS. That version
# supports 'resize' which allows us resize the partition without
# reboot. This is a temporary solution until we've integrated CoreOS
# changes into our copy of cgpt or have a separate tool to do
# the same (http://brbug.com/1209).

EAPI=5
EGIT_REPO_URI="https://chromium.googlesource.com/external/github.com/coreos/seismograph"
EGIT_COMMIT="8881575d1372b860744afe57b52a153a03c80c6a"
AUTOTOOLS_AUTORECONF=1

KEYWORDS="*"

inherit git-2 autotools-utils systemd

DESCRIPTION="An upstart task that resizes stateful partition"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="sys-apps/util-linux"
DEPEND="${RDEPEND}"

DEST_DIRECTORY="/usr/share/cloud"

src_configure() {
	# The source code contains a few tautological comparisons
	# caused by comparing unsigned integer to 0.
	# TODO(andreyu): this is not ideal. Separate resize functionality
	# out of cgpt tool and put it into our own repository.
	export CFLAGS="-Wno-tautological-compare"
	autotools-utils_src_configure
}

src_install() {
	systemd_dounit "${FILESDIR}"/resize-stateful-partition.service
	systemd_enable_service sysinit.target resize-stateful-partition.service

	exeinto ${DEST_DIRECTORY}
	doexe "${BUILD_DIR}/cgpt"
	doexe "${FILESDIR}/resize-stateful"
}
