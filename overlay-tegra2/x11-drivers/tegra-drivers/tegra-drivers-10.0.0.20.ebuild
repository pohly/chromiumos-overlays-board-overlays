# Copyright (c) 2010 The Chromium OS Authors. All rights reserved.
# Copyright (c) 2011 NVIDIA Corporation
# Distributed under the terms of the GNU General Public License v2

# The package version (i.e. ${PV}) represents the video driver ABI version of
# the server, plus the version of the LDK that the driver comes from.  For
# example, the X driver for xserver 1.9 (which uses ABI version 8) from LDK
# version 1.2.3 would be tegra-drivers-8.1.2.3.

EAPI=2

inherit cros-binary

DESCRIPTION="Tegra2 user-land drivers"
SLOT="0"
KEYWORDS="~arm"
IUSE="tegra-local-bins hardfp"

DEPEND=""
RDEPEND="sys-apps/nvrm
        >=x11-base/xorg-server-1.10
        <x11-base/xorg-server-1.11
	chromeos-base/tegra-initscripts"

ABI=`echo "${PV}" | cut -d. -f1`
LDK=`echo "${PV}" | cut -d. -f2-`

if use tegra-local-bins; then
	URI_BASE="file://"
else
	URI_BASE="ssh://tegra2-private@git.chromium.org:6222/home/tegra2-private"
fi
if use hardfp; then
	CROS_BINARY_URI="${URI_BASE}/${CATEGORY}/${PN}/${PN}-hardfp-abi${ABI}-${LDK}.tbz2"
	CROS_BINARY_SUM="fe6f4681864bae10acdb21a96bc3b6024e86af88"
else
	CROS_BINARY_URI="${URI_BASE}/${CATEGORY}/${PN}/${PN}-abi${ABI}-${LDK}.tbz2"
	CROS_BINARY_SUM="74d1a6099cb5e505c4f2044dab4fb72df94f44ae"
fi
