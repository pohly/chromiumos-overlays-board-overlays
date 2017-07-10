# Copyright (c) 2015 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="4"

inherit pam

DESCRIPTION="Lakitu-specific variant of chromeos-auth-config"
HOMEPAGE="http://www.chromium.org"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND="!<=sys-apps/shadow-4.1.2.2-r6
	>=sys-auth/pambase-20090620.1-r7
	!chromeos-base/chromeos-auth-config"
DEPEND="${RDEPEND}"

S="${WORKDIR}"

src_install() {
	pamd_mimic system-auth sudo auth account session
	pamd_mimic system-local-login login auth account password session
}

pkg_postinst() {
	# Enable pam_tty_audit in system-auth PAM config if it's not already there.
	local pamfile="${ROOT}"/etc/pam.d/system-auth
	if ! grep -qa tty_audit "${pamfile}"; then
		echo -e "session\trequired\tpam_tty_audit.so enable=*" >> "${pamfile}"
	fi
}
