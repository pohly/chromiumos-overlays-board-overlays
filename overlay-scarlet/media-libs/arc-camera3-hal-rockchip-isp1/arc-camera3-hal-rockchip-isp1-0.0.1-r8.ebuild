# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT="bdcd418c1d93e5cc146f4a518cabdb9093e21323"
CROS_WORKON_TREE="bd484644c3b6d1b537188d4a52cf0597eaa35b29"
CROS_WORKON_PROJECT="chromiumos/platform/arc-camera"
CROS_WORKON_LOCALNAME="../platform/arc-camera"

inherit autotools cros-debug cros-workon libchrome toolchain-funcs

DESCRIPTION="Rockchip ISP1 ARC++ camera HAL v3"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="-* arm arm64"

RDEPEND="
	!media-libs/arc-camera3-hal-usb
	media-libs/arc-camera3-libcbm
	media-libs/libsync
	media-libs/rockchip-isp1-3a-libs-bin"

DEPEND="${RDEPEND}
	media-libs/arc-camera3-android-headers
	media-libs/arc-camera3-libcab
	media-libs/arc-camera3-libcamera_client
	media-libs/arc-camera3-libcamera_jpeg
	media-libs/arc-camera3-libcamera_metadata
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
	dosym libcamerahal.so /usr/$(get_libdir)/camera_hal.so
}
