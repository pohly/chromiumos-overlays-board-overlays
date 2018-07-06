# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4

DESCRIPTION="Virtual for OpenGLES implementations"

SLOT="0"
KEYWORDS="-* arm64 arm"
IUSE=""

# TODO: Fix this when we have 64bit mali drivers. For now we build a mock library for arm64.
DEPEND="
	arm64? ( x11-drivers/opengles-9999 )
	!arm64? ( media-libs/mali-drivers-bin )
	x11-drivers/opengles-headers
"
RDEPEND="${DEPEND}"
