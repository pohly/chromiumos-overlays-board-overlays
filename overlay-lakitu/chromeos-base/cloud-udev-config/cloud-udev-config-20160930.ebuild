# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=5

inherit udev

PACKAGE="compute-image-packages-${PV}"

SRC_URI="https://github.com/GoogleCloudPlatform/compute-image-packages/archive/${PV}.tar.gz -> ${PACKAGE}.tar.gz"

DESCRIPTION="A package containing udev configuration."
HOMEPAGE="http://github.com/GoogleCloudPlatform/compute-image-packages/tree/master"
LICENSE="BSD-Google"

S="${WORKDIR}/${PACKAGE}/google_config"

KEYWORDS="*"
SLOT="0"
IUSE=""

src_install() {
	udev_dorules udev/64-gce-disk-removal.rules
	udev_dorules udev/65-gce-disk-naming.rules
}
