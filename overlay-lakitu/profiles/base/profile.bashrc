
# Load all additional bashrc files we have for this package.
lakitu_stack_bashrc() {
        local cfgd

        cfgd="/mnt/host/source/src/overlays/overlay-lakitu/${CATEGORY}/${PN}"
        for cfg in ${PN} ${P} ${PF} ; do
                cfg="${cfgd}/${cfg}.bashrc"
                [[ -f ${cfg} ]] && . "${cfg}"
        done
}
lakitu_stack_bashrc

