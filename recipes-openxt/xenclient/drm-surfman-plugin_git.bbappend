DEPENDS += "mesa-dri (>=9.1.4)"
RDEPENDS += "mesa-dri-driver-nouveau mesa-dri-driver-nouveau-vieux mesa-dri-driver-i965"

#The new plugin seems a bit large to patch-queue. 
SRC_URI = "git://github.com/ktemkin/surfman.git;branch=opengl_modern;protocol=${OPENXT_GIT_PROTOCOL}"

PR .= "0.1"
