# Copyright 2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
CROS_WORKON_COMMIT="e78788bdc7c9a1b030a07e1e811b23f1eabf88b8"
CROS_WORKON_TREE="201003644f2e5621620452d8a9cfd90e44978b08"
CROS_WORKON_PROJECT="chromiumos/platform/arc-camera"
CROS_WORKON_LOCALNAME="../platform/arc-camera"

inherit cros-debug cros-workon libchrome toolchain-funcs

DESCRIPTION="ARC camera HAL v3 buffer mapper."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="-asan"

RDEPEND="
	media-libs/minigbm
	x11-libs/libdrm"

DEPEND="${RDEPEND}
	media-libs/arc-camera3-android-headers
	virtual/pkgconfig"

src_compile() {
	asan-setup-env
	tc-export CC CXX PKG_CONFIG
	cros-debug-add-NDEBUG
	emake BASE_VER=${LIBCHROME_VERS} libcbm
}

src_install() {
	local INCLUDE_DIR="/usr/include/arc"
	local LIB_DIR="/usr/$(get_libdir)"

	dolib common/libcbm.so

	insinto "${INCLUDE_DIR}"
	doins include/arc/camera_buffer_mapper.h
	doins include/arc/camera_buffer_mapper_typedefs.h

sed -e "s|@INCLUDE_DIR@|${INCLUDE_DIR}|" -e "s|@LIB_DIR@|${LIB_DIR}|" \
	-e "s|@LIBCHROME_VERS@|${LIBCHROME_VERS}|" \
	common/libcbm.pc.template > common/libcbm.pc
	insinto "${LIB_DIR}/pkgconfig"
	doins common/libcbm.pc
}

src_test() {
	emake BASE_VER=${LIBCHROME_VERS} tests

	if use x86 || use amd64; then
		./common/camera_buffer_mapper_unittest || \
		die "camera_buffer_mapper unit tests failed!"
	fi
}
