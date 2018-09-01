# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Virtual for OpenGLES implementations"

SLOT="0"
KEYWORDS="-* arm"
IUSE=""

DEPEND="
	media-libs/mali-drivers-bifrost-bin
	x11-drivers/opengles-headers
"
RDEPEND="${DEPEND}"
