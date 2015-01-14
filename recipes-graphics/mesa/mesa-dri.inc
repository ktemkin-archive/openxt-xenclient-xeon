PROTO_DEPS += "dri2proto"
LIB_DEPS += "libdrm expat"

# most of our targets do not have DRI so will use mesa-xlib
DEFAULT_PREFERENCE = "-1"

DRI_DRIVERS = "swrast"
#TODO: Add intel back to the two below! Eventually add radeon?
DRI_DRIVERS_append_x86 = ",nouveau,i915,i965"
DRI_DRIVERS_append_x86-64 = ",nouveau,i915,i965"
GALLIUM_DRIVERS = "swrast"
GALLIUM_DRIVERS_append_x86 = ",nouveau"
GALLIUM_DRIVERS_append_x86-64 = ",nouveau"


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

