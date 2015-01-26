SRC_URI += "file://fix-for-bad-caching-policy-using-Linux-XenFB.patch;patch=1;patchdir=.."
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
PR += ".1"
