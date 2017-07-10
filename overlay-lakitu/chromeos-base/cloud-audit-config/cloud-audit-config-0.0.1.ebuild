# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI="4"

inherit systemd

DESCRIPTION="Security audit configuration scripts."
HOMEPAGE=""

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

S=${WORKDIR}

RDEPEND="
	net-firewall/iptables
	sys-auth/pambase
	sys-libs/pam[audit]
	sys-process/audit
"

DEST_DIRECTORY="/usr/share/cloud/audit"

src_install() {
	# Install everything into /usr/share/cloud/audit.
	# Only setup.sh should be executable.
	exeinto "${DEST_DIRECTORY}"
	doexe "${FILESDIR}"/setup.sh

	insinto "${DEST_DIRECTORY}"
	doins "${FILESDIR}"/[0-9][0-9]-*.sh

	doins "${FILESDIR}"/exclude.sh

	systemd_dounit "${FILESDIR}"/cloud-audit-setup.service
}
