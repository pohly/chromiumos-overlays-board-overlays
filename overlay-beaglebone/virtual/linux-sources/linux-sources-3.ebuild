# Copyright (c) 2013 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4

DESCRIPTION="Chrome OS Kernel virtual package"
HOMEPAGE="http://src.chromium.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE_KERNEL_VERS=(
	kernel-3_8
	kernel-4_4
)
IUSE="${IUSE_KERNEL_VERS[*]}"
REQUIRED_USE="^^ ( ${IUSE_KERNEL_VERS[*]} )"

RDEPEND="
	kernel-3_8? ( sys-kernel/kernel-beaglebone )
	kernel-4_4? ( sys-kernel/kernel-beaglebone-4_4 )
"
