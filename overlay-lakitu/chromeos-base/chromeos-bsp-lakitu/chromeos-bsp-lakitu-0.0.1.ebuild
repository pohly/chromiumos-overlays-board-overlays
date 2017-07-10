# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit systemd

DESCRIPTION="Board-specific packages for Lakitu"
HOMEPAGE="http://src.chromium.org"
SRC_URI=""

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="-* amd64"
IUSE="crash_reporting"

RDEPEND="
	sys-apps/baselayout
"

S="${WORKDIR}"

src_install() {
	insinto /etc
	doins "${FILESDIR}"/nsswitch.conf

	insinto /etc
	doins "${FILESDIR}"/os-release

	if use crash_reporting; then
		exeinto /opt/google/crash-reporter
		newexe "${FILESDIR}"/crash-filter filter
	fi

	insinto "$(systemd_get_unitdir)/systemd-networkd-wait-online.service.d"
	doins "${FILESDIR}"/networkd-no-timeout.conf

	insinto /etc/profile.d/
	doins ${FILESDIR}/editor.sh
}

pkg_postinst() {
	# Ensure /etc/hosts file has entry for metadata server.
	local entry="169.254.169.254 metadata.google.internal metadata"
	local hosts="${ROOT}"/etc/hosts
	if ! grep -qs "${entry}" "${hosts}"; then
		echo "${entry}" >> "${hosts}"
	fi
}
