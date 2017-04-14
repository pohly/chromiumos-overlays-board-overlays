# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/systemd/systemd.git"
	inherit git-r3
else
	SRC_URI="https://github.com/systemd/systemd/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	RESTRICT="mirror"
	KEYWORDS="*"
fi

inherit autotools bash-completion-r1 linux-info multilib \
	multilib-minimal pam systemd toolchain-funcs udev user

DESCRIPTION="System and service manager for Linux"
HOMEPAGE="http://www.freedesktop.org/wiki/Software/systemd"

LICENSE="GPL-2 LGPL-2.1 public-domain"
SLOT="0/2"
IUSE="acl apparmor audit cryptsetup curl elfutils gcrypt gnuefi http
	idn importd +kdbus +kmod +lz4 lzma nat pam policykit
	qrcode +seccomp selinux ssl sysv-utils test xkb"

REQUIRED_USE="importd? ( curl gcrypt lzma )"

MINKV="3.11"

COMMON_DEPEND=">=sys-apps/util-linux-2.20:0=[${MULTILIB_USEDEP}]
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
	idn? ( net-dns/libidn:0= )
	importd? (
		app-arch/bzip2:0=
		sys-libs/zlib:0=
	)
	kmod? ( >=sys-apps/kmod-15:0= )
	lz4? ( >=app-arch/lz4-0_p119:0=[${MULTILIB_USEDEP}] )
	lzma? ( >=app-arch/xz-utils-5.0.5-r1:0=[${MULTILIB_USEDEP}] )
	nat? ( net-firewall/iptables:0= )
	pam? ( virtual/pam:= )
	qrcode? ( media-gfx/qrencode:0= )
	seccomp? ( sys-libs/libseccomp:0= )
	selinux? ( sys-libs/libselinux:0= )
	sysv-utils? (
		!sys-apps/systemd-sysv-utils
		!sys-apps/sysvinit
		!sys-apps/upstart )
	xkb? ( >=x11-libs/libxkbcommon-0.4.1:0= )
	abi_x86_32? ( !<=app-emulation/emul-linux-x86-baselibs-20130224-r9
		!app-emulation/emul-linux-x86-baselibs[-abi_x86_32(-)] )"

# baselayout-2.2 has /run
RDEPEND="${COMMON_DEPEND}
	>=sys-apps/baselayout-2.2
	!sys-auth/nss-myhostname
	!sys-fs/eudev
	!sys-fs/udev"

# sys-apps/dbus: the daemon only (+ build-time lib dep for tests)
PDEPEND=">=sys-apps/dbus-1.6.8-r1:0[systemd]
	policykit? ( sys-auth/polkit )"

# Newer linux-headers needed by ia64, bug #480218
DEPEND="${COMMON_DEPEND}
	app-arch/xz-utils:0
	dev-util/gperf
	>=dev-util/intltool-0.50
	>=sys-apps/coreutils-8.16
	>=sys-devel/binutils-2.23.1
	>=sys-devel/gcc-4.6
	>=sys-kernel/linux-headers-${MINKV}
	virtual/pkgconfig
	gnuefi? ( >=sys-boot/gnu-efi-3.0.2 )
	test? ( >=sys-apps/dbus-1.6.8-r1:0 )
	>=dev-libs/libgcrypt-1.4.5:0"

pkg_pretend() {
	local CONFIG_CHECK="~AUTOFS4_FS ~BLK_DEV_BSG ~CGROUPS
		~DEVPTS_MULTIPLE_INSTANCES ~DEVTMPFS ~DMIID ~EPOLL ~FANOTIFY ~FHANDLE
		~INOTIFY_USER ~IPV6 ~NET ~NET_NS ~PROC_FS ~SECCOMP ~SIGNALFD ~SYSFS
		~TIMERFD ~TMPFS_XATTR
		~!FW_LOADER_USER_HELPER ~!GRKERNSEC_PROC ~!IDE ~!SYSFS_DEPRECATED
		~!SYSFS_DEPRECATED_V2"

	use acl && CONFIG_CHECK+=" ~TMPFS_POSIX_ACL"
	kernel_is -lt 3 7 && CONFIG_CHECK+=" ~HOTPLUG"

	if linux_config_exists; then
		local uevent_helper_path=$(linux_chkconfig_string UEVENT_HELPER_PATH)
			if [ -n "${uevent_helper_path}" ] && [ "${uevent_helper_path}" != '""' ]; then
				ewarn "It's recommended to set an empty value to the following kernel config option:"
				ewarn "CONFIG_UEVENT_HELPER_PATH=${uevent_helper_path}"
			fi
	fi

	if [[ ${MERGE_TYPE} != binary ]]; then
		if [[ $(gcc-major-version) -lt 4
			|| ( $(gcc-major-version) -eq 4 && $(gcc-minor-version) -lt 6 ) ]]
		then
			eerror "systemd requires at least gcc 4.6 to build. Please switch the active"
			eerror "gcc version using gcc-config."
			die "systemd requires at least gcc 4.6"
		fi
	fi

	if [[ ${MERGE_TYPE} != buildonly ]]; then
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
	# Bug 463376
	sed -i -e 's/GROUP="dialout"/GROUP="uucp"/' rules/*.rules || die
	epatch "${FILESDIR}/226-noclean-tmp.patch"
	epatch "${FILESDIR}/CVE-2015-7510.patch"
	epatch "${FILESDIR}/226-kcmp.patch"

	# Do not create /srv
	epatch "${FILESDIR}/225-tmpfiles-no-srv.patch"
	epatch "${FILESDIR}/225-audit-set-pid.patch"
	epatch "${FILESDIR}/225-oom-score.patch"
	epatch "${FILESDIR}/225-nspawn-sigchld.patch"

	epatch "${FILESDIR}/225-CVE-2016-7795.patch"
	epatch "${FILESDIR}/225-CVE-2016-7796.patch"

	# Lakitu: allow networkd => hostnamed communication w/o polkit.
	epatch "${FILESDIR}/225-allow-networkd-to-hostnamed.patch"

	epatch "${FILESDIR}/225-single-label-hostname.patch"
	epatch "${FILESDIR}/225-Force-re-creation-of-etc-localtime-symlink.patch"

	# Lakitu: make networkd default to not touch IP forwarding setting.
	# BUG 33257712
	epatch "${FILESDIR}/225-networkd-default-ip-forwarding-to-kernel.patch"

	# Lakitu: don't install uaccess rules without acl
	epatch "${FILESDIR}/225-no-uaccess.patch"

	epatch_user
	eautoreconf
}

src_configure() {
	# Keep using the one where the rules were installed.
	MY_UDEVDIR=$(get_udevdir)
	# Fix systems broken by bug #509454.
	[[ ${MY_UDEVDIR} ]] || MY_UDEVDIR=/lib/udev

	# Prevent conflicts with i686 cross toolchain, bug 559726
	tc-export AR CC NM OBJCOPY RANLIB

	multilib-minimal_src_configure
}

multilib_src_configure() {
	local myeconfargs=(
		# disable -flto since it is an optimization flag
		# and makes distcc less effective
		cc_cv_CFLAGS__flto=no

		# Workaround for gcc-4.7, bug 554454.
		cc_cv_CFLAGS__Werror_shadow=no

		# Workaround for bug 516346
		--enable-dependency-tracking

		--disable-maintainer-mode
		--localstatedir=/var
		--with-pamlibdir=$(getpam_mod_dir)
		# avoid bash-completion dep
		--with-bashcompletiondir="$(get_bashcompdir)"
		# make sure we get /bin:/sbin in $PATH
		--enable-split-usr
		# For testing.
		--with-rootprefix="${ROOTPREFIX-/usr}"
		--with-rootlibdir="${ROOTPREFIX-/usr}/$(get_libdir)"
		# disable sysv compatibility
		--with-sysvinit-path=
		--with-sysvrcnd-path=
		# no deps
		--without-python
		--with-ntp-servers=metadata.google.internal

		# Optional components/dependencies
		$(multilib_native_use_enable acl)
		$(multilib_native_use_enable cryptsetup libcryptsetup)
		$(multilib_native_use_enable curl libcurl)
		$(multilib_native_use_enable elfutils)
		$(use_enable gcrypt)
		$(multilib_native_use_enable gnuefi)
		$(multilib_native_use_enable http microhttpd)
		$(usex http $(multilib_native_use_enable ssl gnutls) --disable-gnutls)
		$(multilib_native_use_enable idn libidn)
		$(multilib_native_use_enable importd)
		$(multilib_native_use_enable importd bzip2)
		$(multilib_native_use_enable importd zlib)
		$(use_enable kdbus)
		$(multilib_native_use_enable kmod)
		$(use_enable lz4)
		$(use_enable lzma xz)
		$(multilib_native_use_enable nat libiptc)
		$(multilib_native_use_enable pam)
		$(multilib_native_use_enable policykit polkit)
		$(multilib_native_use_enable qrcode qrencode)
		$(multilib_native_use_enable seccomp)
		$(multilib_native_use_enable selinux)
		$(multilib_native_use_enable apparmor)
		$(multilib_native_use_enable test tests)
		$(multilib_native_use_enable test dbus)
		$(use_enable audit)

		# hardcode a few paths to spare some deps
		QUOTAON=/usr/sbin/quotaon
		QUOTACHECK=/usr/sbin/quotacheck

		# TODO: we may need to restrict this to gcc
		EFI_CC="$(tc-getCC)"

		# dbus paths
		--with-dbuspolicydir="${EPREFIX}/etc/dbus-1/system.d"
		--with-dbussessionservicedir="${EPREFIX}/usr/share/dbus-1/services"
		--with-dbussystemservicedir="${EPREFIX}/usr/share/dbus-1/system-services"
	)

	myeconfargs+=(
		--enable-networkd
		--enable-hostnamed
		--enable-resolved
	)

	# Lakitu: Disable all features that we are not using and which are not otherwise
	# disabled by USE flags.
	myeconfargs+=(
		--disable-backlight
		--disable-bootchart
		--disable-efi
		--disable-firstboot
		--disable-gnuefi
		--disable-hibernate
		--disable-hwdb
		--disable-localed
		--disable-machined
		--disable-manpages
		--disable-microhttpd
		--disable-myhostname
		--disable-quotacheck
		--disable-randomseed
		--disable-rfkill
		--disable-sysusers
		--disable-timedated
		--disable-utmp
		--disable-vconsole
		--disable-xkbcommon
	)

	# Work around bug 463846.
	tc-export CC

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_compile() {
	local mymakeopts=(
		udevlibexecdir="${MY_UDEVDIR}"
	)

	if multilib_is_native_abi; then
		emake "${mymakeopts[@]}"
	else
		echo 'gentoo: $(BUILT_SOURCES)' | \
		emake "${mymakeopts[@]}" -f Makefile -f - gentoo
		echo 'gentoo: $(lib_LTLIBRARIES) $(pkgconfiglib_DATA)' | \
		emake "${mymakeopts[@]}" -f Makefile -f - gentoo
	fi
}

multilib_src_test() {
	multilib_is_native_abi || continue

	# Needed for bus-related tests
	local -x SANDBOX_WRITE=${SANDBOX_WRITE}
	addwrite /sys/fs/kdbus

	default
}

multilib_src_install() {
	local mymakeopts=(
		# automake fails with parallel libtool relinking
		# https://bugs.gentoo.org/show_bug.cgi?id=491398
		-j1

		udevlibexecdir="${MY_UDEVDIR}"
		dist_udevhwdb_DATA=
		DESTDIR="${D}"
	)

	if multilib_is_native_abi; then
		emake "${mymakeopts[@]}" install
	else
		mymakeopts+=(
			install-libLTLIBRARIES
			install-pkgconfiglibDATA
			install-includeHEADERS
			# safe to call unconditionally, 'installs' empty list
			install-pkgincludeHEADERS
		)

		emake "${mymakeopts[@]}"
	fi

	# install compat pkg-config files
	# Change dbus to >=sys-apps/dbus-1.8.8 if/when this is dropped.
	local pcfiles=( src/compat-libs/libsystemd-{daemon,id128,journal,login}.pc )
	emake "${mymakeopts[@]}" install-pkgconfiglibDATA \
		pkgconfiglib_DATA="${pcfiles[*]}"
}

multilib_src_install_all() {
	local unitdir=$(systemd_get_unitdir)

	prune_libtool_files --modules

	if use sysv-utils; then
		for app in halt poweroff reboot runlevel shutdown telinit; do
			dosym "..${ROOTPREFIX-/usr}/bin/systemctl" /sbin/${app}
		done
		dosym "..${ROOTPREFIX-/usr}/lib/systemd/systemd" /sbin/init
	fi

	# Disable storing coredumps in journald, bug #433457
	mv "${D}"/usr/lib/sysctl.d/50-coredump.conf{,.disabled} || die

	# Preserve empty dirs in /etc & /var, bug #437008
	keepdir /etc/binfmt.d /etc/modules-load.d /etc/tmpfiles.d \
		/etc/systemd/ntp-units.d /etc/systemd/user /var/lib/systemd \
		/var/log/journal/remote

	# Symlink /etc/sysctl.conf for easy migration.
	dosym ../sysctl.conf /etc/sysctl.d/99-sysctl.conf

	# Lakitu:
	dosym /usr/bin/udevadm sbin/udevadm
	dosym /usr/lib/systemd/systemd-udevd sbin/udevd
	dosym /run/systemd/resolve/resolv.conf etc/resolv.conf

	# Lakitu: Disable all sysctl settings. In ChromeOS sysctl.conf is
	# provided by chromeos-base.
	rm "${D}"/usr/lib/sysctl.d/*

	# Lakitu: install our systemd-preset file.
	insinto /usr/lib/systemd/system-preset
	rm -f "${D}"/usr/lib/systemd/system-preset/*
	doins "${FILESDIR}"/00-lakitu.preset

	# Lakitu: there is no VT so no need for getty on tty1
	rm  -f "${D}"/etc/systemd/system/getty.target.wants/getty@tty1.service

	# Lakitu: Install network files.
	insinto /usr/lib/systemd/network
	doins "${FILESDIR}"/*.network

	# Lakitu: Don't boot into graphical.target
	rm "${D}${unitdir}"/default.target || die
	dosym multi-user.target "${unitdir}"/default.target
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

migrate_net_name_slot() {
	# If user has disabled 80-net-name-slot.rules using a empty file or a symlink to /dev/null,
	# do the same for 80-net-setup-link.rules to keep the old behavior
	local net_move=no
	local net_name_slot_sym=no
	local net_rules_path="${EROOT%/}"/etc/udev/rules.d
	local net_name_slot="${net_rules_path}"/80-net-name-slot.rules
	local net_setup_link="${net_rules_path}"/80-net-setup-link.rules
	if [[ -e ${net_setup_link} ]]; then
		net_move=no
	elif [[ -f ${net_name_slot} && $(sed -e "/^#/d" -e "/^\W*$/d" ${net_name_slot} | wc -l) == 0 ]]; then
		net_move=yes
	elif [[ -L ${net_name_slot} && $(readlink ${net_name_slot}) == /dev/null ]]; then
		net_move=yes
		net_name_slot_sym=yes
	fi
	if [[ ${net_move} == yes ]]; then
		ebegin "Copying ${net_name_slot} to ${net_setup_link}"

		if [[ ${net_name_slot_sym} == yes ]]; then
			ln -nfs /dev/null "${net_setup_link}"
		else
			cp "${net_name_slot}" "${net_setup_link}"
		fi
		eend $? || FAIL=1
	fi
}

reenable_unit() {
	if systemctl is-enabled --root="${ROOT}" "$1" &> /dev/null; then
		ebegin "Re-enabling $1"
		systemctl reenable --root="${ROOT}" "$1"
		eend $? || FAIL=1
	fi
}

pkg_postinst() {
	newusergroup() {
		enewgroup "$1"
		enewuser "$1" -1 -1 -1 "$1"
	}

	enewgroup input
	enewgroup systemd-journal
	newusergroup systemd-timesync
	newusergroup systemd-network
	newusergroup systemd-resolve

	# Lakitu: Disable groups not currently used.
	# newusergroup systemd-bus-proxy
	# newusergroup systemd-journal-gateway
	# newusergroup systemd-journal-remote
	# newusergroup systemd-journal-upload

	use http && newusergroup systemd-journal-gateway

	# Lakitu: Enable accounting for all supported controllers (CPU, Memory and Block)
	sed -i 's/#DefaultCPUAccounting=no/DefaultCPUAccounting=yes/' "${ROOT}"/etc/systemd/system.conf
	sed -i 's/#DefaultBlockIOAccounting=no/DefaultBlockIOAccounting=yes/' "${ROOT}"/etc/systemd/system.conf
	sed -i 's/#DefaultMemoryAccounting=no/DefaultMemoryAccounting=yes/' "${ROOT}"/etc/systemd/system.conf

	# Lakitu: Set default log rotation policy: 100M for each journal; 1G total.
	sed -i 's/#SystemMaxUse=/SystemMaxUse=1G/' "${ROOT}"/etc/systemd/journald.conf
	sed -i 's/#SystemMaxFileSize=/SystemMaxFileSize=100M/' "${ROOT}"/etc/systemd/journald.conf

	# Lakitu: Enable persistent storage for the journal
	sed -i 's/#Storage=auto/Storage=persistent/' "${ROOT}"/etc/systemd/journald.conf

	systemd_update_catalog

	# Keep this here in case the database format changes so it gets updated
	# when required. Despite that this file is owned by sys-apps/hwids.
	if has_version "sys-apps/hwids[udev]"; then
		udevadm hwdb --update --root="${ROOT%/}"
	fi

	udev_reload || FAIL=1

	# Bug 465468, make sure locales are respect, and ensure consistency
	# between OpenRC & systemd
	migrate_locale

	# Migrate 80-net-name-slot.rules -> 80-net-setup-link.rules
	migrate_net_name_slot

	# Re-enable systemd-networkd for socket activation
	reenable_unit systemd-networkd.service

	if [[ ${FAIL} ]]; then
		eerror "One of the postinst commands failed. Please check the postinst output"
		eerror "for errors. You may need to clean up your system and/or try installing"
		eerror "systemd again."
		eerror
	fi

	if [[ $(readlink "${ROOT}"/etc/resolv.conf) == */run/systemd/network/resolv.conf ]]; then
		ewarn "resolv.conf is now generated by systemd-resolved. To use it, enable"
		ewarn "systemd-resolved.service, and create a symlink from /etc/resolv.conf"
		ewarn "to /run/systemd/resolve/resolv.conf"
		ewarn
	fi
}

pkg_prerm() {
	# If removing systemd completely, remove the catalog database.
	if [[ ! ${REPLACED_BY_VERSION} ]]; then
		rm -f -v "${EROOT}"/var/lib/systemd/catalog/database
	fi
}
