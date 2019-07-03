# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="ab0130d4141642ad200d4158ebd2e37c8fbfda97"
CROS_WORKON_TREE=("dc1506ef7c8cfd2c5ffd1809dac05596ec18773c" "7134e391e4c04513211b250b665951820d5b0bbd" "f49bd8e6b19c7b36f4b3eb8e7aa73ff7cd0eb7d9" "54dd9638ff917a8e54996b8c4cadedca0ba28b0f" "2624ca1aeb7f546093c8cac8244297955cb1481d" "79935d3039bad820fa03c8bded635ad197ad74ab" "3203fc5c38912e1d0625e33126a801b6ae1a0c59" "0c09044de6eac9d7b509ecafedc623265c6b7b02")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_SUBTREE=".gn camera/build camera/common camera/hal/intel camera/include camera/mojo common-mk metrics"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera"
PLATFORM_GYP_FILE="hal/intel/libcamera_hal.gyp"

inherit cros-camera cros-workon platform

DESCRIPTION="Intel IPU3 (Image Processing Unit) Chrome OS camera HAL"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="-* amd64"

RDEPEND="
	dev-libs/expat
	media-libs/cros-camera-libcab
	media-libs/cros-camera-libcamera_client
	media-libs/cros-camera-libcamera_common
	media-libs/cros-camera-libcamera_exif
	media-libs/cros-camera-libcamera_metadata
	media-libs/cros-camera-libcamera_v4l2_device
	media-libs/cros-camera-libcbm
	media-libs/intel-3a-libs-bin
	media-libs/intel-pvl-libs-bin
	media-libs/libsync"

DEPEND="${RDEPEND}
	chromeos-base/metrics
	media-libs/cros-camera-android-headers
	media-libs/libyuv
	sys-kernel/linux-headers
	virtual/jpeg:0
	virtual/pkgconfig"

HAL_DIR="hal/intel"

src_install() {
	dolib.so "${OUT}/lib/libcam_algo.so"
	cros-camera_dohal "${OUT}/lib/libcamera_hal.so" intel-ipu3.so
}
