# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
EGO_PN="github.com/containerd/${PN}"

# lakitu: inherits eutils and systemd to install the containerd.service.
inherit eutils toolchain-funcs systemd

if [[ ${PV} == *9999 ]]; then
	inherit golang-vcs
else
	MY_PV="${PV/_rc/-rc.}"
	EGIT_COMMIT="v${MY_PV}"
	CONTAINERD_COMMIT="bb71b10fd8f58240ca47fbb579b9d1028eea7c84"
	SRC_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="*"
	inherit golang-vcs-snapshot
fi

DESCRIPTION="A daemon to control runC"
HOMEPAGE="https://containerd.tools"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="apparmor +btrfs +cri hardened +seccomp"

DEPEND="btrfs? ( sys-fs/btrfs-progs )
	seccomp? ( sys-libs/libseccomp )"

# lakitu: RDEPEND on sys-apps/systemd because of the dependency on
# containerd.service.
RDEPEND=">=app-emulation/runc-1.0.0_rc5
	seccomp? ( sys-libs/libseccomp )
	sys-apps/systemd"

S=${WORKDIR}/${P}/src/${EGO_PN}

PATCHES=(
	# lakitu: uses Go cross compiler in the builder (i.e. ${GO}) rather than
	# the default go compiler in the builders (i.e. go).
	"${FILESDIR}"/1.2.5-use-GO-cross-compiler.patch
	# lakitu: patches upstream containerd.service because lakitu installs
	# containerd at /usr/bin/containerd, different than upstream's default at
	# /usr/local/bin/containerd
	"${FILESDIR}"/1.2.2-correct-execstart-path.patch
)

RESTRICT="test"

src_prepare() {
	default
	if [[ ${PV} != *9999* ]]; then
		sed -i -e "s/git describe --match.*$/echo ${PV})/"\
			-e "s/git rev-parse HEAD.*$/echo $CONTAINERD_COMMIT)/"\
			-e "s/-s -w//" \
			Makefile || die
	fi
}

src_compile() {
	local options=( $(usex btrfs "" "no_btrfs") $(usex cri "" "no_cri") $(usex seccomp "seccomp" "") $(usex apparmor "apparmor" "") )
	export GOPATH="${WORKDIR}/${P}" # ${PWD}/vendor
	# lakitu: specifies containerd failure behavior.
	export GOTRACEBACK="crash"
	# lakitu: create environment variable ${GO} to point to the Go cross
	# compiler.
	GO=$(tc-getGO)
	export GO
	LDFLAGS=$(usex hardened '-extldflags -fno-PIC' '') BUILDTAGS="${options[@]}" emake
}

src_install() {
	# lakitu: we use systemd service to start containerd.
	# newinitd "${FILESDIR}"/${PN}.initd ${PN}
	keepdir /var/lib/containerd
	dobin bin/containerd{-shim,-stress,} bin/ctr

	# lakitu: runs containerd as an individual service. This prevents
	# docker from supervising containerd.
	systemd_dounit containerd.service
}
