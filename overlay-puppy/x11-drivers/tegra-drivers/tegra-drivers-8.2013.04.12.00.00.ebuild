# Copyright (c) 2013 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

# The package version (i.e. ${PV}) represents the video driver ABI version of
# the server, plus the version of the LDK that the driver comes from.  For
# example, the X driver for xserver 1.9 (which uses ABI version 8) from LDK
# version 1.2.3 would be tegra-drivers-8.1.2.3.

EAPI=4

inherit multilib versionator

DESCRIPTION="Tegra4 user-land drivers"
MY_ABI=$(get_major_version)
MY_PV=$(get_after_major_version)
SRC_URI="http://download.nvidia.com/chromeos/binary-ldk/t114/ER/${MY_PV//./_}/nvidia-binaries_armhf_${MY_PV//./_}.tbz2"

LICENSE="NVIDIA"
SLOT="0"
KEYWORDS="arm"
IUSE=""

RDEPEND="=sys-apps/nvrm-${MY_PV}
	=x11-base/xorg-server-1.${MY_ABI}*"

S=${WORKDIR}

src_unpack() {
	default
	unpack ./Linux_for_Tegra/nv_tegra/nvidia_drivers.tbz2
}

src_install() {
	exeinto /usr/$(get_libdir)/xorg/modules/drivers
	newexe usr/lib/xorg/modules/drivers/tegra_drv.abi${MY_ABI}.so tegra_drv.so
}
