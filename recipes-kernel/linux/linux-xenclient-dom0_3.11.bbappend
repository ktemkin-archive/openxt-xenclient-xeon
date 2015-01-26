FILESEXTRAPATHS_prepend := "${THISDIR}/files"

do_configure_prepend() {

  sed -i "/CONFIG_DRM_RADEON/d" ${S}/.config
  echo "CONFIG_DRM_RADEON=m" >> ${S}/.config  

  sed -i "/CONFIG_DRM_RADEON/d" ${S}/.config
  echo "CONFIG_DRM_RADEON=m" >> ${S}/.config  
}

PV += ".1"
