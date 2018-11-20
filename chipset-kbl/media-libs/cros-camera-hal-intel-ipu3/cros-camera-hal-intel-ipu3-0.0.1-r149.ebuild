# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT=("65fb571a71df26d167c0c693a9588e9329ae375d" "7e952db80e672b5d14fd8ce0019b3ad28a3e63f9")
CROS_WORKON_TREE=("6589055d0d41e7fc58d42616ba5075408d810f7d" "6fe849f6084435dceedb04196043db83ef6d9ca6" "5aa2bdc92600cbba67b37a455ef2bedb6334c1ad")
CROS_WORKON_PROJECT=(
	"chromiumos/platform/arc-camera"
	"chromiumos/platform2"
)
CROS_WORKON_LOCALNAME=(
	"../platform/arc-camera"
	"../platform2"
)
CROS_WORKON_DESTDIR=(
	"${S}/platform/arc-camera"
	"${S}/platform2"
)
CROS_WORKON_SUBTREE=(
	"build hal/intel"
	"common-mk"
)
PLATFORM_GYP_FILE="hal/intel/libcamera_hal.gyp"

inherit cros-camera cros-workon

DESCRIPTION="Intel IPU3 (Image Processing Unit) Chrome OS camera HAL"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="-* amd64"

RDEPEND="
	dev-libs/expat
	media-libs/cros-camera-libcab
	media-libs/cros-camera-libcamera_client
	media-libs/cros-camera-libcamera_common
	media-libs/cros-camera-libcamera_jpeg
	media-libs/cros-camera-libcamera_metadata
	media-libs/cros-camera-libcamera_v4l2_device
	media-libs/cros-camera-libcbm
	media-libs/intel-3a-libs-bin
	media-libs/libsync"

DEPEND="${RDEPEND}
	chromeos-base/libmojo
	media-libs/cros-camera-android-headers
	media-libs/libyuv
	sys-kernel/linux-headers
	virtual/jpeg:0
	virtual/pkgconfig"

HAL_DIR="hal/intel"

src_unpack() {
	cros-camera_src_unpack
}

src_install() {
	dolib.so "${OUT}/lib/libcam_algo.so"
	cros-camera_dohal "${OUT}/lib/libcamera_hal.so" intel-ipu3.so
}
