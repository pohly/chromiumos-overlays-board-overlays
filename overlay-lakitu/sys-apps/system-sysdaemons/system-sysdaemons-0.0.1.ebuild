# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=5

inherit systemd

DESCRIPTION="Package that installs and configures system-sysdaemons.slice"
LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
S="${WORKDIR}"

SERVICES="
	device_policy_manager.service
	google-accounts-daemon.service
	google-clock-skew-daemon.service
	google-ip-forwarding-daemon.service
	metrics-daemon.service
	update-engine.service
"


src_install() {
	local -r unitdir=$(systemd_get_unitdir)

	insinto "${unitdir}"
	doins "${FILESDIR}"/system-sysdaemons.slice

	for service in ${SERVICES[@]}; do
		insinto "${unitdir}"/"${service}".d
		doins "${FILESDIR}"/00-system-sysdaemons-slice.conf
	done
}
