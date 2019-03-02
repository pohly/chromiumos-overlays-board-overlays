# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Install the lxc base container as part of the image."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND="!<chromeos-base/chromeos-bsp-moblab-0.0.1-r53"


LXC_STORAGE_BASE_URI="https://storage.googleapis.com/abci-ssp/autotest-containers"
LXC_BASE_IMAGE_FILE="moblab_base_08.tar.xz"
SRC_URI="${LXC_STORAGE_BASE_URI}/${LXC_BASE_IMAGE_FILE}"

S=${WORKDIR}

src_unpack() {
	return
}

src_install() {
	insinto /moblab-base-container
	doins "${DISTDIR}/${LXC_BASE_IMAGE_FILE}"
}
