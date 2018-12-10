# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Chrome OS Model configuration package for coral"
HOMEPAGE="http://src.chromium.org"

LICENSE="BSD-Google"
SLOT="0/${PF}"
KEYWORDS="-* amd64 x86"

inherit cros-unibuild

S=${WORKDIR}

RDEPEND="
	!<chromeos-base/chromeos-config-bsp-coral-private-0.0.1-r1102
"

# From an ideological purity perspective, this DEPEND should be there, but
# it can't be, since otherwise we end up with circular dependencies.
# DEPEND="virtual/chromeos-bsp"

src_install(){
	insinto "${CROS_MODELS_DIR}"
	doins -r "${FILESDIR}"/*

	install_model_files

	insinto "${CROS_CONFIG_TEST_DIR}"
	doins "${FILESDIR}/config_dump.json"
	doins "${FILESDIR}/file_dump.txt"
	doins "${FILESDIR}/file_dump.sh"
	chmod 755 "${D}${CROS_CONFIG_TEST_DIR}/file_dump.sh"
}
