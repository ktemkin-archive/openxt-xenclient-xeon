#
# Tweak the installer to prevent use of the discrete graphics plugins
# during installation.
#

PR .= ".2"

#Also look in the layer when searching for SRC_URI files.
FILESEXTRAPATHS_prepend := "${THISDIR}/drm-surfman-plugin:"

#Also bring in our discrete grapics configuration.
SRC_URI += "file://discrete_gfx.conf"

#
# And install our discrete graphics configruation to the right location.
#
do_install_append() {
    install -d ${D}/etc/modprobe.
    install -m 0644 ${WORKDIR}/discrete_gfx.conf ${D}/etc/modprobe.d/discrete_gfx.conf
}
