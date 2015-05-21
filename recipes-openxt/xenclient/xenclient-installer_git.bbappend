FILESEXTRAPATHS_prepend := "${THISDIR}/xenclient-installer:"

SRC_URI += " \
    file://disable-nvidia-unsupported-warning.patch \
    file://quirk-for-dom0-numa-affinity.patch \
"
PR .= ".2"
