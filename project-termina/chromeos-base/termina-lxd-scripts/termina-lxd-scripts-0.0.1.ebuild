# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=5

DESCRIPTION="Install configuration and scripts for lxd"
HOMEPAGE="http://www.chromium.org/"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="
	dev-util/shflags
	sys-fs/btrfs-progs
"

S=${WORKDIR}

src_install() {
	dobin "${FILESDIR}"/run_container.sh
	dosbin "${FILESDIR}"/lxd_setup.sh
	dosbin "${FILESDIR}"/stateful_setup.sh

	insinto /usr/share/
	doins "${FILESDIR}"/container_sshd_config
}
