FILESEXTRAPATHS_prepend := "${THISDIR}/xenclient-installer:"

SRC_URI += "file://up-carrier-timeout.patch;patch=1 \
            file://add-multi-gpu.patch;patch=1"

PR .= ".2"
