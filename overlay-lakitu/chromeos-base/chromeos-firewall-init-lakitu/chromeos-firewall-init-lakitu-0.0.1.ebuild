# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=5

DESCRIPTION="Install the upstart jobs that configure the firewall."
HOMEPAGE="http://www.chromium.org/"
LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

S=${WORKDIR}

inherit systemd

RDEPEND="
	!chromeos-base/chromeos-firewall-init
	net-firewall/iptables[ipv6]
"

src_install() {
	exeinto /usr/share/cloud
	doexe "${FILESDIR}"/iptables-setup
	doexe "${FILESDIR}"/ip6tables-setup

	systemd_dounit "${FILESDIR}"/iptables-setup.service
	systemd_enable_service basic.target iptables-setup.service
	systemd_dounit "${FILESDIR}"/ip6tables-setup.service
	systemd_enable_service basic.target ip6tables-setup.service
}
