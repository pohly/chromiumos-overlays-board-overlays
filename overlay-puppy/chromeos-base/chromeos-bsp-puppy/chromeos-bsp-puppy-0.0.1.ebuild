# Copyright (c) 2013 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4

DESCRIPTION="Puppy bsp (meta package to pull in driver/tool dependencies)"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="arm"
IUSE="opengles tegra-ldk"

DEPEND="sys-boot/chromeos-bootimage"
RDEPEND="
	tegra-ldk? (
		opengles? ( media-libs/openmax media-libs/openmax-codecs )
		<x11-drivers/tegra-drivers-13.0.0.4
	)
"

S=${WORKDIR}
