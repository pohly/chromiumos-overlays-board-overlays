# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT="44de25940ce7360454b3f4e581aba46ad1b0cd67"
CROS_WORKON_TREE="c12cf8d787e73b8b9b2f80ae07ef373025c21dcf"
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
