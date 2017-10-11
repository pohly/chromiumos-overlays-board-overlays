# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=5

GIT_COMMIT_ID="02e2fc61bd2fb7f0045f15db105de7b8ace3029f"
SRC_URI="https://github.com/rhboot/shim/archive/${GIT_COMMIT_ID}.tar.gz -> ${P}.tar.gz"
KEYWORDS="*"

inherit multilib

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
	insinto /usr/lib/shim
	doins "shimx64.efi"
}
