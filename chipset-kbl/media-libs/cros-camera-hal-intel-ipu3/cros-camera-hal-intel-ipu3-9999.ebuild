# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_PROJECT="chromiumos/platform/arc-camera"
CROS_WORKON_LOCALNAME="../platform/arc-camera"

inherit autotools cros-debug cros-workon libchrome toolchain-funcs

DESCRIPTION="Intel IPU3 (Image Processing Unit) Chrome OS camera HAL"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="-* ~amd64"

RDEPEND="
	!media-libs/arc-camera3-hal-intel-ipu3
	media-libs/cros-camera-libcbm
	media-libs/intel-3a-libs-bin
	media-libs/libsync"

DEPEND="${RDEPEND}
	dev-libs/expat
	media-libs/cros-camera-android-headers
	media-libs/cros-camera-libcab
	media-libs/cros-camera-libcamera_client
	media-libs/cros-camera-libcamera_common
	media-libs/cros-camera-libcamera_jpeg
	media-libs/cros-camera-libcamera_metadata
	media-libs/libyuv
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
	econf --with-ipu=ipu3 --with-base-version=${BASE_VER} --enable-remote3a
}

src_compile() {
	tc-export CC CXX PKG_CONFIG

	cd ${HAL_DIR}
	emake
}

src_install() {
	# install hal libs to dev
	cd ${HAL_DIR}
	dolib.so .libs/libcam_algo.so*
	dolib.so .libs/libcamerahal.so*
	dosym ../libcamerahal.so /usr/$(get_libdir)/camera_hal/intel-ipu3.so
}
