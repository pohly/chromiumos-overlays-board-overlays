# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Install public keys for chronos"
HOMEPAGE="http://www.chromium.org/"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

S="${WORKDIR}"

RDEPEND="
	chromeos-base/chromeos-ssh-testkeys
"

src_install() {
	local filenames=(
		authorized_keys
		id_rsa
		id_rsa.pub
	)
	local filename

	for filename in "${filenames[@]}"; do
		dosym /usr/share/chromeos-ssh-config/keys/"${filename}" \
		      /home/chronos/user/.ssh/"${filename}"
	done
}
