# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT="3bebd0b43be79476c9f49a0ba6bd939fe793f769"
CROS_WORKON_TREE="58e2a7ade04103973004d077141b123db0fc75d5"
CROS_WORKON_PROJECT="chromiumos/third_party/kernel"
CROS_WORKON_LOCALNAME="kernel/v4.14"

CHROMEOS_KERNEL_CONFIG="${FILESDIR}/base.config"

# This must be inherited *after* EGIT/CROS_WORKON variables defined
inherit cros-workon cros-kernel2 osreleased

STRIP_MASK+=" /usr/src/${P}/build/vmlinux"
STRIP_MASK+=" *.ko"

DESCRIPTION="Chromium OS Linux Kernel 4.14"
HOMEPAGE="https://www.chromium.org/chromium-os/chromiumos-design-docs/chromium-os-kernel"
KEYWORDS="*"
IUSE="module_sign gpu"

src_configure() {
	if use module_sign ; then
		# Provide a custom key configuration file, because otherwise the kernel
		# would auto-generate one.
		mkdir -p "$(cros-workon_get_build_dir)/certs"
		cp -f "${FILESDIR}/x509.genkey" \
			"$(cros-workon_get_build_dir)/certs/x509.genkey" || die
		# Different board use different root key.
		if use gpu ; then
			# The root key belongs to lakitu-gpu board.
			cp -f "${FILESDIR}/lakitu_gpu_root_cert.pem" \
				"$(cros-workon_get_build_dir)/certs/trusted_key.pem" || die
		else
			# The root key belongs to lakitu board.
			cp -f "${FILESDIR}/lakitu_root_cert.pem" \
				"$(cros-workon_get_build_dir)/certs/trusted_key.pem" || die
		fi
	fi
	cros-kernel2_src_configure
}

tar_kernel_source() {
	# Put kernel source tarball under /opt to avoid it gets
	# masked by INSTALL_MASK.
	local source_dir=opt/google/src
	dodir "${source_dir}"
	pushd "${D}/usr/src/${P}"
	tar --exclude="./build" -czf "${D}/${source_dir}/kernel-src.tar.gz" .
	popd
}

write_toolchain_env() {
	# Write the compiler info used for kernel compilation
	# in toolchain_env
	local toolchain_env_dir=etc
	# Example for toolchain_env content:
	# CC=x86_64-cros-linux-gnu-gcc
	# CXX=x86_64-cros-linux-gnu-g++
	# The file will be deleted after copying data to BUILD_DIR artifact
	echo "CC=${CC}" > "${D}/${toolchain_env_dir}/toolchain_env"
	echo "CXX=${CXX}" >> "${D}/${toolchain_env_dir}/toolchain_env"
}

src_install() {
	cros-kernel2_src_install

	# VCSID variable is unconditionally set by the cros-workon eclass, and
	# is in the form of "<ebuild_revision>-<sha1>".
	do_osrelease_field "KERNEL_COMMIT_ID" "${VCSID##*-}"

	# Install kernel source tarball so it can be exported as an
	# artifact later.
	tar_kernel_source
	# Install kernel compiler information
	write_toolchain_env
}

# Change the following (commented out) number to the next prime number
# when you change base.config.  This workaround will force the
# ChromeOS CQ to uprev sys-kernel/lakitu-kernel-4_14 ebuild and pick up the
# configuration changes.  In absence of this workaround the config changes
# would not be picked up unless there was a code change in kernel source tree.
#
# NOTE: There's nothing magic keeping this number prime but you just need to
# make _any_ change to this file.  ...so why not keep it prime?
#
# The coolest prime number is: 89
