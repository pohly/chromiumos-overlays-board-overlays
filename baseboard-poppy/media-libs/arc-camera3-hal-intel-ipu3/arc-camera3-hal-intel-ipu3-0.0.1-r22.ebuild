# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT="51d952b3c953b15b81b9a72ea5f3f731a2019920"
CROS_WORKON_TREE="76edfc733511a052c17eb665975d3d0be3f1313c"
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
	cd ${HAL_DIR}
	econf --with-ipu=ipu3 --with-base-version=${BASE_VER}
}

src_compile() {
	tc-export CC CXX PKG_CONFIG
	cros-debug-add-NDEBUG

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
