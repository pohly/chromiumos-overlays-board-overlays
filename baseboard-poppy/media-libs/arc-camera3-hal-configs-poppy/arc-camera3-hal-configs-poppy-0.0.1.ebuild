# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

KEYWORDS="-* amd64"

DESCRIPTION="Camera HAL config files for Poppy"

LICENSE="Apache-2.0 LICENSE.intel_3a_library"
SLOT="0"

S="${WORKDIR}"

src_install() {
	insinto /etc/camera
	doins "${FILESDIR}"/camera3_profiles.xml
	doins "${FILESDIR}"/gcss/*.xml
	doins "${FILESDIR}"/setup-hooks.sh

	insinto /etc/camera/ipu3
	doins "${FILESDIR}"/tuning_files/*.aiqb
}

