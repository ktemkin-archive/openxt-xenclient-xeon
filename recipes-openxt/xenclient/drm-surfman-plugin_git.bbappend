PR .= "0.3"

#Also look in the layer when searching for SRC_URI files.
FILESEXTRAPATHS_prepend := "${THISDIR}/drm-surfman-plugin:"

#Override the source repository, until the layer is merged.
SRC_URI = "git://github.com/ktemkin/surfman.git;branch=opengl_modern;protocol=git"

#Add our discrete graphics module handers.
SRC_URI += " \
    file://discrete_gfx_modprobe.sh \
    file://discrete_gfx.conf \
"
FILES_${PN} += " \
    /etc/modprobe.d/discrete_gfx.conf \
    /usr/share/xenclient/discrete_gfx_modprobe.sh \
"

#Add Mesa and its drivers to the list of DRM plugin dependencies.
DEPENDS  += "mesa-dri (>=9.1.4)"
RDEPENDS += "mesa-dri-driver-nouveau mesa-dri-driver-nouveau-vieux mesa-dri-driver-i965"

#
# In addition to installing the main DRM surfman plugin, install our
# "modprobe" support files, which ensure that adding discrete graphics
# support doesn't break GPU passthrough.
#
do_install_append() {
    install -d ${D}/etc/modprobe.d
    install -d ${D}/usr/share/xenclient

    #Install the script used to insert the discrete graphics plugins...
    install -m 0755 ${WORKDIR}/discrete_gfx_modprobe.sh \
        ${D}/usr/share/xenclient/discrete_gfx_modprobe.sh

    #... and install the modprobe rule that forces our script to be used
    #for graphic module insertion.
    install -m 0644 ${WORKDIR}/discrete_gfx.conf \
        ${D}/etc/modprobe.d/discrete_gfx.conf
}
