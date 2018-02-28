# Copyright (c) 2010 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_PROJECT="chromiumos/platform/cobble"
CROS_WORKON_LOCALNAME="../platform/cobble"
CROS_WORKON_SUBTREE="grub-lakitu"

inherit autotools eutils toolchain-funcs multiprocessing cros-workon

DESCRIPTION="GNU GRUB 2 boot loader"
HOMEPAGE="http://www.gnu.org/software/grub/"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE=""

DEPEND="dev-lang/python"

export STRIP_MASK="*.img *.mod *.module"

# The ordering doesn't seem to matter.
PLATFORMS=( "efi" )
TARGETS=( "x86_64" )

src_unpack() {
	cros-workon_src_unpack
	S="${WORKDIR}/${P}/grub-lakitu"
}

src_prepare() {
	default
	sed -i -e /autoreconf/d autogen.sh || die
	bash autogen.sh || die
	autopoint() { :; }
	eautoreconf -vi
}

src_configure() {
	local platform target
	# Fix timestamps to prevent unnecessary rebuilding
	find "${S}" -exec touch -r "${S}/configure" {} +
	multijob_init
	for platform in "${PLATFORMS[@]}" ; do
		for target in "${TARGETS[@]}" ; do
			mkdir -p ${target}-${platform}-build
			pushd ${target}-${platform}-build >/dev/null
			# GRUB defaults to a --program-prefix set based on target
			# platform; explicitly set it to nothing to install unprefixed
			# tools.  https://savannah.gnu.org/bugs/?39818
			ECONF_SOURCE="${S}" multijob_child_init econf_build \
				--disable-werror \
				--disable-grub-mkfont \
				--disable-grub-mount \
				--disable-device-mapper \
				--disable-efiemu \
				--disable-libzfs \
				--disable-nls \
				--sbindir=/sbin \
				--bindir=/bin \
				--libdir=/$(get_libdir) \
				--with-platform=${platform} \
				--target=${target} \
				--prefix="${D}"
			popd >/dev/null
		done
	done
	multijob_finish
}

src_compile() {
	local platform target
	multijob_init
	for platform in "${PLATFORMS[@]}" ; do
		for target in "${TARGETS[@]}" ; do
			multijob_child_init \
				emake -C ${target}-${platform}-build -j1
		done
	done
	multijob_finish
}

src_install() {
	local platform target
	# The installations have several file conflicts that prevent
	# parallel installation.
	for platform in "${PLATFORMS[@]}" ; do
		for target in "${TARGETS[@]}" ; do
			emake -C ${target}-${platform}-build DESTDIR="${D}" \
				install
		done
	done
	"${D}/bin/grub-mkimage" -O x86_64-efi \
		-p "(hd0,gpt12)/efi/boot" \
		-d "${D}/$(get_libdir)/grub/x86_64-efi" \
		-o "${S}/grub-lakitu.efi" \
		part_gpt gptpriority test fat ext2 hfs hfsplus normal boot \
		chain efi_gop configfile search search_fs_uuid search_label \
		terminal memdisk echo serial linuxefi
	rm -Rf "${D}"/*
	insinto /usr/lib/grub-lakitu
	doins "grub-lakitu.efi"
}
