# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cros-constants cros-unibuild

DESCRIPTION="Chrome OS Model configuration package for drallion."

LICENSE="BSD-Google"
SLOT="0/${PF}"
KEYWORDS="* amd64 x86"
S="${WORKDIR}"

src_install() {
	install_model_files
}
