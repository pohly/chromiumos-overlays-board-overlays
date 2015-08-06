# Copyright (c) 2015 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="4"

DESCRIPTION="Install Chromium OS test public keys for ssh clients on test image"
HOMEPAGE="http://www.chromium.org/"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

S="${WORKDIR}"

RDEPEND="
	chromeos-base/chromeos-ssh-testkeys
	!chromeos-base/chromeos-test-testauthkeys
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
		      /root/.ssh/"${filename}"
	# Private key will be deleted from the image for security reasons.
	# Moblab is special because it needs it present at boot time so name it
	# differently to avoid deletion.
	insinto /root/.ssh
	newins "${EROOT}"/usr/share/chromeos-ssh-config/keys/id_rsa moblab_id_rsa
	fperms 600 /root/.ssh/moblab_id_rsa
	newins "${FILESDIR}"/ssh_config config
	fperms 600 /root/.ssh/config
	done
}
