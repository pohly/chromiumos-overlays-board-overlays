# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT="124fc9020c3ece1d41d0d9d94ec63fd70b1d3eed"
CROS_WORKON_TREE="3b5abad3a7fa76e9dd3acdcd4ab768b2d90afd40"
CROS_WORKON_PROJECT="chromiumos/platform/arc-camera"
CROS_WORKON_LOCALNAME="../platform/arc-camera"

inherit autotools cros-debug cros-workon libchrome toolchain-funcs

DESCRIPTION="Rockchip ISP1 Chrome OS camera HAL"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="-* arm arm64"

RDEPEND="
	dev-libs/expat
	!media-libs/arc-camera3-hal-rockchip-isp1
	media-libs/cros-camera-libcab
	media-libs/cros-camera-libcamera_client
	media-libs/cros-camera-libcamera_jpeg
	media-libs/cros-camera-libcamera_metadata
	media-libs/cros-camera-libcbm
	media-libs/libsync
	media-libs/rockchip-isp1-3a-libs-bin"

DEPEND="${RDEPEND}
	media-libs/cros-camera-android-headers
	media-libs/libyuv
	sys-kernel/linux-headers
	virtual/jpeg:0
	virtual/pkgconfig"

HAL_DIR="hal/rockchip"

src_prepare() {
	cd "${HAL_DIR}"
	eautoreconf
}

src_configure() {
	cros-debug-add-NDEBUG

	cd ${HAL_DIR}
	econf --with-base-version=${BASE_VER} --enable-remote3a
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
	dosym ../libcamerahal.so /usr/$(get_libdir)/camera_hal/rockchip-isp1.so
}
