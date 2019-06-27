# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2.

# This package installs a kernel module loadpin-trigger.ko and configures
# OS to load the module on boot. The kernel module calls
# kernel_read_file_from_path to load a dummy file into kernel, which will
# trigger loadpin. We used to rely on loading kernel modules to pin to
# rootfs, but the recent kernel param loadpin.exclude=kernel-module we added
# makes loadpin ignore module loading.

EAPI=6
inherit linux-info linux-mod toolchain-funcs

DESCRIPTION="Kernel module to trigger loadpin on boot"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE="clang kernel-4_14 kernel-4_19"

DEPEND="
	kernel-4_14? ( sys-kernel/lakitu-kernel-4_14[kernel_sources] )
	kernel-4_19? ( sys-kernel/lakitu-kernel-4_19[kernel_sources] )
"

RDEPEND="
	${DEPEND}
"

S="${WORKDIR}"

# Prevent kernel module signature being striped.
STRIP_MASK+=" *.ko"

MODULE_NAME="loadpin_trigger"

# Because our kernel version string ends with '+' (e.g.
# "4.4.21+"), Gentoo Linux's linux-info.eclass cannot locate the kernel build
# output directory. Hence we set it up here.
KBUILD_OUTPUT="${KERNEL_DIR}"/build

pkg_setup() {
	CONFIG_CHECK=""
	MODULE_NAMES="${MODULE_NAME}(::)"
	linux-mod_pkg_setup
	BUILD_PARAMS="KERNEL_SOURCES=${KV_DIR} KBUILD_OUTPUT=${KBUILD_OUTPUT}"
}

src_prepare() {
	cp "${FILESDIR}"/* .

	# use gcc as long as clang USE flag is not set.
	# This is copied from cros-kernel2.eclass to make sure the third
	# party kernel module uses the same compiler as kernel.
	use clang || cros_use_gcc

	default
}

src_compile() {
	BUILD_TARGETS="module" linux-mod_src_compile
}

src_install() {
	# Sign the module first.
	cp ${MODULE_NAME}.ko ${MODULE_NAME}.ko.orig
	"${KBUILD_OUTPUT}"/scripts/sign-file \
		sha256 \
		"${KBUILD_OUTPUT}"/certs/signing_key.pem \
		"${KBUILD_OUTPUT}"/certs/signing_key.x509 \
		${MODULE_NAME}.ko

	linux-mod_src_install

	# Install a dummy file to rootfs. The file will be read by
	# loadpin-trigger so that rootfs will be pinned.
	insinto /
	newins "${FILESDIR}"/loadpin_trigger_dummy .loadpin_trigger
}
