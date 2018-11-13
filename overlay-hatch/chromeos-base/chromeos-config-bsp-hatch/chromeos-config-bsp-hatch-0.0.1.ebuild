# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

DESCRIPTION="Chrome OS Model configuration package for hatch"
HOMEPAGE="http://src.chromium.org"

LICENSE="BSD-Google"
SLOT="0/${PF}"
KEYWORDS="-* amd64 x86"

inherit cros-model cros-unibuild

src_install() {
	install_model_files
}
