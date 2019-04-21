# Copyright 2011-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/systemd/systemd.git"
	inherit git-r3
else
	SRC_URI="https://github.com/systemd/systemd/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="*"
fi

PYTHON_COMPAT=( python{3_4,3_5,3_6,3_7} )

inherit bash-completion-r1 linux-info meson multilib-minimal ninja-utils pam python-any-r1 systemd toolchain-funcs udev user

DESCRIPTION="System and service manager for Linux"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/systemd"

LICENSE="GPL-2 LGPL-2.1 MIT public-domain"
SLOT="0/2"

# lakitu: Added "doc" USE flag to conditionalize the installation of docs.
IUSE="acl apparmor audit build cryptsetup curl doc elfutils +gcrypt gnuefi http idn importd +kmod libidn2 +lz4 lzma nat pam pcre policykit qrcode +resolvconf +seccomp selinux +split-usr ssl +sysv-utils test vanilla xkb"

REQUIRED_USE="importd? ( curl gcrypt lzma )"
RESTRICT="!test? ( test )"

MINKV="3.11"

COMMON_DEPEND=">=sys-apps/util-linux-2.30:0=[${MULTILIB_USEDEP}]
	sys-libs/libcap:0=[${MULTILIB_USEDEP}]
	!<sys-libs/glibc-2.16
	acl? ( sys-apps/acl:0= )
	apparmor? ( sys-libs/libapparmor:0= )
	audit? ( >=sys-process/audit-2:0= )
	cryptsetup? ( >=sys-fs/cryptsetup-1.6:0= )
	curl? ( net-misc/curl:0= )
	elfutils? ( >=dev-libs/elfutils-0.158:0= )
	gcrypt? ( >=dev-libs/libgcrypt-1.4.5:0=[${MULTILIB_USEDEP}] )
	http? (
		>=net-libs/libmicrohttpd-0.9.33:0=
		ssl? ( >=net-libs/gnutls-3.1.4:0= )
	)
	idn? (
		libidn2? ( net-dns/libidn2:= )
		!libidn2? ( net-dns/libidn:= )
	)
	importd? (
		app-arch/bzip2:0=
		sys-libs/zlib:0=
	)
	kmod? ( >=sys-apps/kmod-15:0= )
	lz4? ( >=app-arch/lz4-0_p131:0=[${MULTILIB_USEDEP}] )
	lzma? ( >=app-arch/xz-utils-5.0.5-r1:0=[${MULTILIB_USEDEP}] )
	nat? ( net-firewall/iptables:0= )
	pam? ( virtual/pam:=[${MULTILIB_USEDEP}] )
	pcre? ( dev-libs/libpcre2 )
	qrcode? ( media-gfx/qrencode:0= )
	seccomp? ( >=sys-libs/libseccomp-2.3.3:0= )
	selinux? ( sys-libs/libselinux:0= )
	xkb? ( >=x11-libs/libxkbcommon-0.4.1:0= )"

# baselayout-2.2 has /run
RDEPEND="${COMMON_DEPEND}
	>=sys-apps/baselayout-2.2
	selinux? ( sec-policy/selinux-base-policy[systemd] )
	sysv-utils? ( !sys-apps/sysvinit )
	!sysv-utils? ( sys-apps/sysvinit )
	resolvconf? ( !net-dns/openresolv )
	!build? ( || (
		sys-apps/util-linux[kill(-)]
		sys-process/procps[kill(+)]
		sys-apps/coreutils[kill(-)]
	) )
	!sys-auth/nss-myhostname
	!<sys-kernel/dracut-044
	!sys-fs/eudev
	!sys-fs/udev"

# sys-apps/dbus: the daemon only (+ build-time lib dep for tests)
# The following PDEPENDs are present in Gentoo upstream but don't make sense for
# lakitu:
#     >=sys-fs/udev-init-scripts-25
# udev-init-scripts: startup scripts for OpenRC
PDEPEND=">=sys-apps/dbus-1.9.8[systemd]
	>=sys-apps/hwids-20150417[udev]
	policykit? ( sys-auth/polkit )
	!vanilla? ( sys-apps/gentoo-systemd-integration )"

# Newer linux-headers needed by ia64, bug #480218
# lakitu: Added conditional doc dependency
DEPEND="${COMMON_DEPEND}
	app-arch/xz-utils:0
	dev-util/gperf
	>=dev-util/intltool-0.50
	>=sys-apps/coreutils-8.16
	>=sys-kernel/linux-headers-${MINKV}
	virtual/pkgconfig[${MULTILIB_USEDEP}]
	gnuefi? ( >=sys-boot/gnu-efi-3.0.2 )
	test? ( sys-apps/dbus )
	doc? (
		app-text/docbook-xml-dtd:4.2
		app-text/docbook-xml-dtd:4.5
		app-text/docbook-xsl-stylesheets
		dev-libs/libxslt:0
		$(python_gen_any_dep 'dev-python/lxml[${PYTHON_USEDEP}]')
	)
"

pkg_pretend() {
	if [[ ${MERGE_TYPE} != buildonly ]]; then
		local CONFIG_CHECK="~AUTOFS4_FS ~BLK_DEV_BSG ~CGROUPS
			~CHECKPOINT_RESTORE ~DEVTMPFS ~EPOLL ~FANOTIFY ~FHANDLE
			~INOTIFY_USER ~IPV6 ~NET ~NET_NS ~PROC_FS ~SIGNALFD ~SYSFS
			~TIMERFD ~TMPFS_XATTR ~UNIX
			~CRYPTO_HMAC ~CRYPTO_SHA256 ~CRYPTO_USER_API_HASH
			~!FW_LOADER_USER_HELPER_FALLBACK ~!GRKERNSEC_PROC ~!IDE ~!SYSFS_DEPRECATED
			~!SYSFS_DEPRECATED_V2"

		use acl && CONFIG_CHECK+=" ~TMPFS_POSIX_ACL"
		use seccomp && CONFIG_CHECK+=" ~SECCOMP ~SECCOMP_FILTER"
		kernel_is -lt 3 7 && CONFIG_CHECK+=" ~HOTPLUG"
		kernel_is -lt 4 7 && CONFIG_CHECK+=" ~DEVPTS_MULTIPLE_INSTANCES"
		kernel_is -ge 4 10 && CONFIG_CHECK+=" ~CGROUP_BPF"

		if linux_config_exists; then
			local uevent_helper_path=$(linux_chkconfig_string UEVENT_HELPER_PATH)
			if [[ -n ${uevent_helper_path} ]] && [[ ${uevent_helper_path} != '""' ]]; then
				ewarn "It's recommended to set an empty value to the following kernel config option:"
				ewarn "CONFIG_UEVENT_HELPER_PATH=${uevent_helper_path}"
			fi
			if linux_chkconfig_present X86; then
				CONFIG_CHECK+=" ~DMIID"
			fi
		fi

		if kernel_is -lt ${MINKV//./ }; then
			ewarn "Kernel version at least ${MINKV} required"
		fi

		check_extra_config
	fi
}

pkg_setup() {
	:
}

src_unpack() {
	default
	[[ ${PV} != 9999 ]] || git-r3_src_unpack
}

src_prepare() {
	# Do NOT add patches here
	local PATCHES=()

	[[ -d "${WORKDIR}"/patches ]] && PATCHES+=( "${WORKDIR}"/patches )

	# Add local patches here
	# lakitu: To want some gentoo patches if not vanilla and to keep the
	# code aligned with gentoo's ebuild file
	#if ! use vanilla; then
	#	PATCHES+=(
	#		"${FILESDIR}/gentoo-Dont-enable-audit-by-default.patch"
	#		"${FILESDIR}/gentoo-systemd-user-pam.patch"
	#		"${FILESDIR}/gentoo-uucp-group-r1.patch"
	#		"${FILESDIR}/gentoo-generator-path.patch"
	#	)
	#fi
	PATCHES+=(
			# Gentoo patches
			"${FILESDIR}/239-debug-extra.patch"
			"${FILESDIR}/CVE-2019-6454.patch"
			"${FILESDIR}/gentoo-uucp-group-r1.patch"
			"${FILESDIR}/gentoo-systemd-user-pam.patch"
			"${FILESDIR}/228-noclean-tmp.patch"
			# lakitu: CL:*250967
			"${FILESDIR}"/232-tmpfiles-no-srv.patch
			# lakitu: CL:*256679
			"${FILESDIR}"/225-Force-re-creation-of-etc-localtime-symlink.patch
			# lakitu: This prevents the kernel from logging all audit messages to
			# both dmesg and audit log. b/29581598.
			"${FILESDIR}"/225-audit-set-pid.patch
			# lakitu: allow networkd => hostnamed communication w/o polkit.
			"${FILESDIR}"/225-allow-networkd-to-hostnamed.patch
			# lakitu: work around the 64 bit restriction of hostname length from
			# kernel. b/27702816.
			"${FILESDIR}"/232-single-label-hostname.patch
			# lakitu: make networkd default to not touch IP forwarding setting.
			# b/33257712
			"${FILESDIR}"/225-networkd-default-ip-forwarding-to-kernel.patch
			# lakitu: Avoid render and kvm group
			"${FILESDIR}"/239-avoid-render-and-kvm-group.patch
			# lakitu: change paths for udev rules, init, halt, poweroff
			# shutdown and reboot to minimize the effect of systemd upgrade
			# TODO(vaibhavrustagi): Need to check to use default paths provided
			# by systemd or not
			"${FILESDIR}"/239-change-paths-for-udev-rules-init-reboot.patch
	)

	default
}

src_configure() {
	# Prevent conflicts with i686 cross toolchain, bug 559726
	tc-export AR CC NM OBJCOPY RANLIB

	# lakitu: Need python setup only when doc USE flag is
	# enabled
	use doc && python_setup

	multilib-minimal_src_configure
}

meson_use() {
	usex "$1" true false
}

meson_multilib() {
	if multilib_is_native_abi; then
		echo true
	else
		echo false
	fi
}

meson_multilib_native_use() {
	if multilib_is_native_abi && use "$1"; then
		echo true
	else
		echo false
	fi
}

multilib_src_configure() {
	local myconf=(
		--localstatedir="${EPREFIX}/var"
		-Dpamlibdir="$(getpam_mod_dir)"
		# avoid bash-completion dep
		-Dbashcompletiondir="$(get_bashcompdir)"
		# lakitu: Do not want the "split-usr" USE flag
		# as it uses rootprefix as "/" and lakitu currently
		# uses "/usr"
		# make sure we get /bin:/sbin in PATH
		-Dsplit-usr=true
		-Drootprefix="$(usex split-usr "${EPREFIX:-/}" "${EPREFIX}/usr")"
		# lakitu: Install libraries at /usr/lib instead of /lib
		-Drootlibdir="$(usex split-usr "${EPREFIX:-/}" "${EPREFIX}/usr/$(get_libdir)")"
		-Dsysvinit-path=
		-Dsysvrcnd-path=
		# Avoid infinite exec recursion, bug 642724
		-Dtelinit-path="${EPREFIX}/lib/sysvinit/telinit"
		# no deps
		# lakitu: no efi
		# -Defi=$(meson_multilib)
		-Dima=true
		# Optional components/dependencies
		-Dacl=$(meson_multilib_native_use acl)
		-Dapparmor=$(meson_multilib_native_use apparmor)
		-Daudit=$(meson_multilib_native_use audit)
		-Dlibcryptsetup=$(meson_multilib_native_use cryptsetup)
		-Dlibcurl=$(meson_multilib_native_use curl)
		-Delfutils=$(meson_multilib_native_use elfutils)
		-Dgcrypt=$(meson_use gcrypt)
		-Dgnu-efi=$(meson_multilib_native_use gnuefi)
		-Defi-libdir="${EPREFIX}/usr/$(get_libdir)"
		-Dmicrohttpd=$(meson_multilib_native_use http)
		$(usex http -Dgnutls=$(meson_multilib_native_use ssl) -Dgnutls=false)
		-Dimportd=$(meson_multilib_native_use importd)
		-Dbzip2=$(meson_multilib_native_use importd)
		-Dzlib=$(meson_multilib_native_use importd)
		-Dkmod=$(meson_multilib_native_use kmod)
		-Dlz4=$(meson_use lz4)
		-Dxz=$(meson_use lzma)
		-Dlibiptc=$(meson_multilib_native_use nat)
		-Dpam=$(meson_use pam)
		-Dpcre2=$(meson_multilib_native_use pcre)
		-Dpolkit=$(meson_multilib_native_use policykit)
		-Dqrencode=$(meson_multilib_native_use qrcode)
		-Dseccomp=$(meson_multilib_native_use seccomp)
		-Dselinux=$(meson_multilib_native_use selinux)
		#-Dtests=$(meson_multilib_native_use test)
		-Ddbus=$(meson_multilib_native_use test)
		-Dxkbcommon=$(meson_multilib_native_use xkb)
		# hardcode a few paths to spare some deps
		-Dkill-path=/bin/kill
		# lakitu: specifying dbus policy dir path
		-Ddbuspolicydir="${EPREFIX}/etc/dbus-1/system.d"
		# lakitu: Use metadata servers for NTP
		-Dntp-servers="metadata.google.internal"
		# -Dntp-servers="0.gentoo.pool.ntp.org 1.gentoo.pool.ntp.org 2.gentoo.pool.ntp.org 3.gentoo.pool.ntp.org"
		# Breaks screen, tmux, etc.
		-Ddefault-kill-user-processes=false
	)

	# lakitu specific enabled features
	myconf+=(
		-Dbinfmt=true
		-Dcoredump=true
		-Dhostnamed=true
		-Dldconfig=true
		-Dnetworkd=true
		-Dtimesyncd=true
		-Dtmpfiles=true
	)

	# lakitu: disable all features not used and not disabled by USE flags.
	# multilib options
	myconf+=(
		-Dbacklight=false
		-Defi=false
		-Denvironment-d=false
		-Dfirstboot=false
		-Dhibernate=false
		-Dhwdb=false
		-Dlocaled=false
		-Dmachined=false
		-Dman=false
		-Dquotacheck=false
		-Drandomseed=false
		-Drfkill=false
		-Dsysusers=false
		-Dtimedated=false
		-Dutmp=false
		-Dvconsole=false
	)

	if multilib_is_native_abi && use idn; then
		myconf+=(
			-Dlibidn2=$(usex libidn2 true false)
			-Dlibidn=$(usex libidn2 false true)
		)
	else
		myconf+=(
			-Dlibidn2=false
			-Dlibidn=false
		)
	fi

	meson_src_configure "${myconf[@]}"
}

multilib_src_compile() {
	eninja
}

multilib_src_test() {
	unset DBUS_SESSION_BUS_ADDRESS XDG_RUNTIME_DIR
	eninja test
}

multilib_src_install() {
	DESTDIR="${D}" eninja install
}

# lakitu specific installation
lakitu_src_install() {
	dosym /usr/bin/udevadm sbin/udevadm
	dosym /usr/lib/systemd/systemd-udevd sbin/udevd
	dosym /run/systemd/resolve/resolv.conf etc/resolv.conf

	# Disable all sysctl settings. In ChromeOS sysctl.conf is
	# provided by chromeos-base.
	rm "${D}"/usr/lib/sysctl.d/*

	# Install our systemd-preset file.
	insinto /usr/lib/systemd/system-preset
	rm -f "${D}"/usr/lib/systemd/system-preset/*
	doins "${FILESDIR}"/00-lakitu.preset

	# There is no VT so no need for getty on tty1
	rm  -f "${D}"/etc/systemd/system/getty.target.wants/getty@tty1.service

	# Install network files.
	insinto /usr/lib/systemd/network
	doins "${FILESDIR}"/*.network

	# Turn off Predictable Network Interface Names to minimize the
	# upgrade side-effects.
	# https://www.freedesktop.org/wiki/Software/systemd/PredictableNetworkInterfaceNames/
	dosym /dev/null /etc/systemd/network/99-default.link

	# Don't boot into graphical.target
	local unitdir=$(systemd_get_systemunitdir)
	rm "${D}"/"${unitdir}"/default.target || die
	dosym multi-user.target "${unitdir}"/default.target
}

multilib_src_install_all() {
	local rootprefix=$(usex split-usr '' /usr)
	# meson doesn't know about docdir
	mv "${ED%/}"/usr/share/doc/{systemd,${PF}} || die

	use doc && einstalldocs

	# lakitu: Do not use nsswitch.conf
	# dodoc "${FILESDIR}"/nsswitch.conf

	if ! use resolvconf; then
		rm -f "${ED%/}${rootprefix}"/sbin/resolvconf || die
	fi

	if ! use sysv-utils; then
		rm "${ED%/}${rootprefix}"/sbin/{halt,init,poweroff,reboot,runlevel,shutdown,telinit} || die
		rm "${ED%/}"/usr/share/man/man1/init.1 || die
		rm "${ED%/}"/usr/share/man/man8/{halt,poweroff,reboot,runlevel,shutdown,telinit}.8 || die
	fi

	if ! use resolvconf && ! use sysv-utils; then
		rmdir "${ED%/}${rootprefix}"/sbin || die
	fi

	# Preserve empty dirs in /etc & /var, bug #437008
	keepdir /etc/{binfmt.d,modules-load.d,tmpfiles.d}
	keepdir /etc/systemd/{ntp-units.d,user} /var/lib/systemd
	# lakitu: Remove hwdb.d as it is not present at /etc/udev
	keepdir /etc/udev/rules.d
	keepdir /var/log/journal/remote

	# Symlink /etc/sysctl.conf for easy migration.
	dosym ../sysctl.conf /etc/sysctl.d/99-sysctl.conf

	# lakitu: Following lines from Gentoo Upstream, but lakitu wants
	# networkd and resolved to start on boot
	# If we install these symlinks, there is no way for the sysadmin to remove them
	# permanently.
	#rm -f "${ED%/}"/etc/systemd/system/multi-user.target.wants/systemd-networkd.service || die
	#rm -f "${ED%/}"/etc/systemd/system/dbus-org.freedesktop.network1.service || die
	#rm -f "${ED%/}"/etc/systemd/system/multi-user.target.wants/systemd-resolved.service || die
	#rm -f "${ED%/}"/etc/systemd/system/dbus-org.freedesktop.resolve1.service || die
	#rm -fr "${ED%/}"/etc/systemd/system/network-online.target.wants || die
	#rm -fr "${ED%/}"/etc/systemd/system/sockets.target.wants || die
	#rm -fr "${ED%/}"/etc/systemd/system/sysinit.target.wants || die

	# lakitu specific
	lakitu_src_install

	# lakitu: Don't remove as these are present in systemd-232
	#local udevdir=/lib/udev
	#rm -r "${ED%/}${udevdir}/hwdb.d" || die

	if use split-usr; then
		# Avoid breaking boot/reboot
		dosym ../../../lib/systemd/systemd /usr/lib/systemd/systemd
		dosym ../../../lib/systemd/systemd-shutdown /usr/lib/systemd/systemd-shutdown
	fi
}

migrate_locale() {
	local envd_locale_def="${EROOT%/}/etc/env.d/02locale"
	local envd_locale=( "${EROOT%/}"/etc/env.d/??locale )
	local locale_conf="${EROOT%/}/etc/locale.conf"

	if [[ ! -L ${locale_conf} && ! -e ${locale_conf} ]]; then
		# If locale.conf does not exist...
		if [[ -e ${envd_locale} ]]; then
			# ...either copy env.d/??locale if there's one
			ebegin "Moving ${envd_locale} to ${locale_conf}"
			mv "${envd_locale}" "${locale_conf}"
			eend ${?} || FAIL=1
		else
			# ...or create a dummy default
			ebegin "Creating ${locale_conf}"
			cat > "${locale_conf}" <<-EOF
				# This file has been created by the sys-apps/systemd ebuild.
				# See locale.conf(5) and localectl(1).

				# LANG=${LANG}
			EOF
			eend ${?} || FAIL=1
		fi
	fi

	if [[ ! -L ${envd_locale} ]]; then
		# now, if env.d/??locale is not a symlink (to locale.conf)...
		if [[ -e ${envd_locale} ]]; then
			# ...warn the user that he has duplicate locale settings
			ewarn
			ewarn "To ensure consistent behavior, you should replace ${envd_locale}"
			ewarn "with a symlink to ${locale_conf}. Please migrate your settings"
			ewarn "and create the symlink with the following command:"
			ewarn "ln -s -n -f ../locale.conf ${envd_locale}"
			ewarn
		else
			# ...or just create the symlink if there's nothing here
			ebegin "Creating ${envd_locale_def} -> ../locale.conf symlink"
			ln -n -s ../locale.conf "${envd_locale_def}"
			eend ${?} || FAIL=1
		fi
	fi
}

# lakitu specific post installation
lakitu_postinst() {
	# Enable accounting for all supported controllers (CPU, Memory and Block)
	sed -i 's/#DefaultCPUAccounting=no/DefaultCPUAccounting=yes/' "${ROOT}"/etc/systemd/system.conf
	sed -i 's/#DefaultBlockIOAccounting=no/DefaultBlockIOAccounting=yes/' "${ROOT}"/etc/systemd/system.conf
	sed -i 's/#DefaultMemoryAccounting=no/DefaultMemoryAccounting=yes/' "${ROOT}"/etc/systemd/system.conf

	# Set default log rotation policy: 100M for each journal; 1G total.
	sed -i 's/#SystemMaxUse=/SystemMaxUse=1G/' "${ROOT}"/etc/systemd/journald.conf
	sed -i 's/#SystemMaxFileSize=/SystemMaxFileSize=100M/' "${ROOT}"/etc/systemd/journald.conf

	# Enable persistent storage for the journal
	sed -i 's/#Storage=auto/Storage=persistent/' "${ROOT}"/etc/systemd/journald.conf
}

pkg_postinst() {
	newusergroup() {
		enewgroup "$1"
		enewuser "$1" -1 -1 -1 "$1"
	}

	enewgroup input
	enewgroup systemd-journal
	newusergroup systemd-network
	newusergroup systemd-resolve
	newusergroup systemd-timesync

	# lakitu: disable groups not used
	# enewgroup kvm 78
	# enewgroup render
	# newusergroup systemd-bus-proxy
	# newusergroup systemd-coredump
	# newusergroup systemd-journal-gateway
	# newusergroup systemd-journal-remote
	# newusergroup systemd-journal-upload

	systemd_update_catalog

	# Keep this here in case the database format changes so it gets updated
	# when required. Despite that this file is owned by sys-apps/hwids.
	if has_version "sys-apps/hwids[udev]"; then
		udevadm hwdb --update --root="${EROOT%/}"
	fi

	udev_reload || FAIL=1

	# Bug 465468, make sure locales are respect, and ensure consistency
	# between OpenRC & systemd
	migrate_locale

	# lakitu: No need to reenable as the symlinks were not disabled above
	# systemd_reenable systemd-networkd.service systemd-resolved.service
	lakitu_postinst

	if [[ ${FAIL} ]]; then
		eerror "One of the postinst commands failed. Please check the postinst output"
		eerror "for errors. You may need to clean up your system and/or try installing"
		eerror "systemd again."
		eerror
	fi
}

pkg_prerm() {
	# If removing systemd completely, remove the catalog database.
	if [[ ! ${REPLACED_BY_VERSION} ]]; then
		rm -f -v "${EROOT}"/var/lib/systemd/catalog/database
	fi
}
