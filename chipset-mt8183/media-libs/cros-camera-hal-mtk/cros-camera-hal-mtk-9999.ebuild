# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_SUBTREE=".gn camera/build camera/common camera/hal/mediatek camera/include camera/mojo common-mk"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera"
PLATFORM_GYP_FILE="hal/mediatek/libcamera_hal.gyp"

inherit cros-camera cros-workon platform

DESCRIPTION="Mediatek ISP Chrome OS camera HAL"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="-* ~arm ~arm64"

RDEPEND="
	media-libs/cros-camera-libcbm
	media-libs/cros-camera-libcab
	media-libs/cros-camera-libcamera_ipc
	media-libs/cros-camera-libcamera_metadata
	media-libs/cros-camera-libcamera_common
	media-libs/cros-camera-libcamera_exif
	media-libs/cros-camera-libcamera_client
	media-libs/cros-camera-libcamera_v4l2_device
	media-libs/mtk-isp-3a-libs-bin
	media-libs/mtk-tuning-libs-bin
	media-libs/cros-camera-test
	media-libs/libsync
	media-libs/mtk-tuning-tools-bin"

DEPEND="${RDEPEND}
	media-libs/cros-camera-android-headers
	sys-kernel/linux-headers
	virtual/pkgconfig
"

HAL_DIR="hal/mediatek"

src_install() {
	# install hal libs to dev
	dolib.so "${OUT}/lib/"*.so
	dobin ${OUT}/setprop
	dobin ${OUT}/getprop
	cros-camera_dohal "${OUT}/lib/libcamera.mt8183.so" mtk_cam_hal.so
}
