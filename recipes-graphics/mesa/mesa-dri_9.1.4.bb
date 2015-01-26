include mesa-common.inc

SRC_URI = "ftp://ftp.freedesktop.org/pub/mesa/older-versions/9.x/${PV}/MesaLib-${PV}.tar.bz2 \
    file://gallium-rtasm-handle-mmap-failures-appropriately.patch;patch=1"
S = "${WORKDIR}/Mesa-${PV}"

SRC_URI[md5sum] = "a2c4e25d0e27918bc67f61bae04d0cb8"
SRC_URI[sha256sum] = "6e858786e9e68e79aa245037d351a664f3a5c05ccdbdc2519307bc06f8ee68da"

do_configure_prepend() {
  #check for python not python2, because python-native does not stage python2 binary/link
  sed -i 's/AC_CHECK_PROGS(\[PYTHON2\], \[python2 python\])/AC_CHECK_PROGS(\[PYTHON2\], \[python python\])/g' ${S}/configure.ac
  # We need builtin_compiler built for buildhost arch instead of target (is provided by mesa-dri-glsl-native)"
  #sed -i "s#\./builtin_compiler#${STAGING_BINDIR_NATIVE}/glsl/builtin_compiler#g" ${S}/src/glsl/Makefile
}

PROTO_DEPS += "dri2proto"
LIB_DEPS += "libdrm expat libselinux libselinux-native"
DEPENDS += "libselinux-native"

# most of our targets do not have DRI so will use mesa-xlib
DEFAULT_PREFERENCE = "-1"

DRI_DRIVERS = "swrast"

#TODO: Add intel back to the two below! Eventually add radeon?
DRI_DRIVERS_append_x86 = ",nouveau,i915,i965"
DRI_DRIVERS_append_x86-64 = ",nouveau,i915,i965"
GALLIUM_DRIVERS = "swrast"
GALLIUM_DRIVERS_append_x86 = ",nouveau"
GALLIUM_DRIVERS_append_x86-64 = ",nouveau"

inherit enable-selinux

EXTRA_OECONF = "\
    --disable-xorg          \
    --disable-xa          \
    --disable-d3d1x         \
    --disable-xlib-glx        \
    --disable-opengl        \
    --disable-glx         \
    --disable-glu         \
    --disable-glw         \
    --disable-glut          \
    --disable-gallium-egl       \
    --disable-gallium-gbm       \
    --disable-gallium-llvm     \
    --with-gallium-drivers=${GALLIUM_DRIVERS} \
    --enable-shared-glapi       \
    --enable-gbm          \
    --enable-opengl         \
    --enable-gles1         \
    --enable-gles2          \
    --enable-egl          \
    --enable-selinux      \
    --with-egl-platforms=drm      \
    --enable-dri          \
    --with-dri-drivers=${DRI_DRIVERS}   \
    "


python populate_packages_prepend() {
	import os.path

	dri_drivers_root = os.path.join(d.getVar('libdir', True), "dri")

	do_split_packages(d, dri_drivers_root, '^(.*)_dri\.so$', 'mesa-dri-driver-%s', 'Mesa %s DRI driver', extra_depends='')

}

PACKAGES_DYNAMIC = "mesa-dri-driver-*"
FILES_${PN}-dbg += "${libdir}/dri/.debug/*"

SRC_URI += "file://COPYING"
PR = "${INC_PR}.2"
