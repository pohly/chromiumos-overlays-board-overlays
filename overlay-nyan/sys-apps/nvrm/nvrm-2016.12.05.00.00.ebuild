# Copyright (c) 2013 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit udev

DESCRIPTION="NVIDIA binary nvrm daemon and libraries for Tegra124"
SRC_URI="http://commondatastorage.googleapis.com/chromeos-localmirror/distfiles/${P}.tbz2"

LICENSE="NVIDIA-r2"
SLOT="0"
KEYWORDS="-* arm"
IUSE=""

RDEPEND="x11-libs/libXext"
DEPEND="${RDEPEND}"

S=${WORKDIR}

src_install() {
	local sover='24.04'

	insinto /lib/firmware
	doins lib/firmware/*

	insinto /lib/firmware/tegra12x
	doins lib/firmware/tegra12x/*

	dolib.so usr/lib/libGLdispatch.so.0
	dolib.so usr/lib/libGL.so.1

	dolib.so usr/lib/libnvavp.so
	dolib.so usr/lib/libnvcolorutil.so
	dolib.so usr/lib/libnvdc.so
	dolib.so usr/lib/libnvddk_2d_v2.so
	dolib.so usr/lib/libnvddk_vic.so

	dolib.so usr/lib/libnvidia-eglcore.so
	dosym libnvidia-eglcore.so /usr/$(get_libdir)/libnvidia-eglcore.so.${sover}
	dolib.so usr/lib/libnvidia-glcore.so
	dosym libnvidia-glcore.so /usr/$(get_libdir)/libnvidia-glcore.so.${sover}
	dolib.so usr/lib/libnvidia-glsi.so
	dosym libnvidia-glsi.so /usr/$(get_libdir)/libnvidia-glsi.so.${sover}
	dolib.so usr/lib/libnvidia-rmapi-tegra.so
	dosym libnvidia-rmapi-tegra.so /usr/$(get_libdir)/libnvidia-rmapi-tegra.so.${sover}
	dolib.so usr/lib/libnvidia-tls.so
	dosym libnvidia-tls.so /usr/$(get_libdir)/libnvidia-tls.so.${sover}

	dolib.so usr/lib/libnvmm.so
	dolib.so usr/lib/libnvmm_contentpipe.so
	dolib.so usr/lib/libnvmm_parser.so
	dolib.so usr/lib/libnvmm_utils.so
	dolib.so usr/lib/libnvmmlite.so
	dolib.so usr/lib/libnvmmlite_audio.so
	dolib.so usr/lib/libnvmmlite_image.so
	dolib.so usr/lib/libnvmmlite_msaudio.so
	dolib.so usr/lib/libnvmmlite_utils.so
	dolib.so usr/lib/libnvmmlite_video.so
	dolib.so usr/lib/libnvos.so
	dolib.so usr/lib/libnvparser.so
	dolib.so usr/lib/libnvrm.so
	dolib.so usr/lib/libnvrm_gpu.so
	dolib.so usr/lib/libnvrm_graphics.so
	dolib.so usr/lib/libnvtnr.so
	dolib.so usr/lib/libnvtvmr.so
	dolib.so usr/lib/libnvwsi.so
	dolib.so usr/lib/libtegrav4l2.so

	udev_dorules "${FILESDIR}"/51-nvrm.rules
}
