# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI="5"

DESCRIPTION="Install configs for launching openssh-server on Termina."
HOMEPAGE="http://www.chromium.org/"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

S=${WORKDIR}

RDEPEND="
	net-misc/openssh
"

src_install() {
	# Termina SSH keys and configuration are installed in a
	# separate place, because they may conflict with chromeos-base.
	insinto /etc/ssh
	doins "${FILESDIR}"/termina_sshd_config
	fperms 600 /etc/ssh/termina_sshd_config
}
