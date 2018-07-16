# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4

DESCRIPTION="Virtual for OpenGLES implementations"

SLOT="0"
KEYWORDS="-* arm64 arm"
IUSE=""

DEPEND="
	arm64? ( media-libs/mali-drivers )
	!arm64? ( media-libs/mali-drivers-bin )
	x11-drivers/opengles-headers
"
RDEPEND="${DEPEND}"
