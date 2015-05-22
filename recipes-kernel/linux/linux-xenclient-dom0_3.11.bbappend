FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://nouveau-use-xen-wmi.patch"

#Rework the current kernel configuration to include the 
#Nouveau and Radeon DRM drivers.
do_configure_prepend() {
  sed -i "/CONFIG_DRM_RADEON/d" ${WORKDIR}/defconfig
  echo "CONFIG_DRM_RADEON=m" >> ${WORKDIR}/defconfig

  sed -i "/CONFIG_DRM_NOUVEAU/d" ${WORKDIR}/defconfig
  echo "CONFIG_DRM_NOUVEAU=m" >> ${WORKDIR}/defconfig
}

PR .= ".3"
