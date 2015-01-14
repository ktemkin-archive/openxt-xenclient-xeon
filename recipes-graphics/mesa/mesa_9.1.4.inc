DEPENDS += "mesa-dri-glsl-native"

SRC_URI = "ftp://ftp.freedesktop.org/pub/mesa/older-versions/9.x/${PV}/MesaLib-${PV}.tar.bz2"
S = "${WORKDIR}/Mesa-${PV}"

SRC_URI[md5sum] = "a2c4e25d0e27918bc67f61bae04d0cb8"
SRC_URI[sha256sum] = "6e858786e9e68e79aa245037d351a664f3a5c05ccdbdc2519307bc06f8ee68da"



do_configure_prepend() {
  #check for python not python2, because python-native does not stage python2 binary/link
  sed -i 's/AC_CHECK_PROGS(\[PYTHON2\], \[python2 python\])/AC_CHECK_PROGS(\[PYTHON2\], \[python python\])/g' ${S}/configure.ac
  # We need builtin_compiler built for buildhost arch instead of target (is provided by mesa-dri-glsl-native)"
  #sed -i "s#\./builtin_compiler#${STAGING_BINDIR_NATIVE}/glsl/builtin_compiler#g" ${S}/src/glsl/Makefile
}
