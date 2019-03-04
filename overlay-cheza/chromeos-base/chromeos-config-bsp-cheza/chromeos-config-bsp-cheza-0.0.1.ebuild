# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Chrome OS Model configuration package for cheza"
HOMEPAGE="http://src.chromium.org"

LICENSE="BSD-Google"
SLOT="0/${PF}"
KEYWORDS="*"

inherit cros-unibuild

S=${WORKDIR}

# From an ideological purity perspective, this DEPEND should be there, but
# it can't be, since otherwise we end up with circular dependencies.
# DEPEND="virtual/chromeos-bsp"

src_install(){
	install_model_files
}
