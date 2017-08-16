# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT="da089946dd9c4a5f89ae8b92de1c0ab401440ae9"
CROS_WORKON_TREE="a614fbd945d71d3a5ea5a6c8f8c30154ea029b60"
CROS_WORKON_PROJECT="chromiumos/platform/arc-camera"
CROS_WORKON_LOCALNAME="../platform/arc-camera"

inherit autotools cros-debug cros-workon libchrome toolchain-funcs

DESCRIPTION="Intel IPU3 (Image Processing Unit) ARC++ camera HAL v3"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="-* amd64"

RDEPEND="media-libs/arc-camera3-libcbm
	media-libs/intel-3a-libs-bin
	media-libs/libsync"

DEPEND="${RDEPEND}
	media-libs/arc-camera3-android-headers
	media-libs/arc-camera3-libcamera_client
	media-libs/arc-camera3-libcamera_metadata
	!media-libs/arc-camera3-libsync
	sys-kernel/linux-headers
	virtual/jpeg:0
	virtual/pkgconfig"

HAL_DIR="hal/intel"


src_prepare() {
	cd ${HAL_DIR}
	eautoreconf
}

src_configure() {
	cros-debug-add-NDEBUG

	cd ${HAL_DIR}
	econf --with-ipu=ipu3 --with-base-version=${BASE_VER}
}

src_compile() {
	tc-export CC CXX PKG_CONFIG

	cd ${HAL_DIR}
	emake
}

src_install() {
	local LIBDIR="/usr/$(get_libdir)"

	# install hal libs to dev
	cd ${HAL_DIR}
	dolib.so .libs/libcamerahal.so*
	dosym "${LIBDIR}"/libcamerahal.so "${LIBDIR}"/camera_hal.so
}
