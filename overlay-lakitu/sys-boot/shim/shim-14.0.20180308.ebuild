# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=5

GIT_COMMIT_ID="79cdb2a215de2ace7d1bf0a294165a04b726c70a"
SRC_URI="https://github.com/rhboot/shim/archive/${GIT_COMMIT_ID}.tar.gz -> ${P}.tar.gz"
KEYWORDS="*"

inherit eutils multilib

DESCRIPTION="Red Hat UEFI shim loader"
HOMEPAGE="https://github.com/rhboot/shim"
LICENSE="BSD-2"
SLOT="0"
IUSE=""

RDEPEND=""
DEPEND="dev-libs/openssl
	sys-boot/gnu-efi"

S="${WORKDIR}/${PN}-${GIT_COMMIT_ID}"

src_compile() {
	emake ARCH="x86_64" \
		CROSS_COMPILE="${CHOST}-" \
		EFI_INCLUDE="${ROOT}/usr/include/efi" \
		EFI_PATH="${ROOT}/usr/$(get_libdir)" \
		COMMITID="${GIT_COMMIT_ID}" \
		DEFAULT_LOADER="\\\\\\\\grub-lakitu.efi" \
		shimx64.efi
}

src_install() {
	insinto /boot/efi/boot
	doins "shimx64.efi"
}
