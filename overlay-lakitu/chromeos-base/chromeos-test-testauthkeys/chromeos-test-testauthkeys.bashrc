cros_post_pkg_postinst_allow_root() {
	elog "Setting PermitRootLogin to without-password"
	sed -i -e 's/PermitRootLogin no/PermitRootLogin without-password/' \
	  ${ROOT}/etc/ssh/sshd_config || die
}
