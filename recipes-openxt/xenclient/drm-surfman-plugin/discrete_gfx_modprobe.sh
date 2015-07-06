#! /bin/sh
#
# Discrete graphics initialization script; correctly loads the modules
# for a discrete graphics card-- ensuring that only the Boot VGA device is
# available for use in dom0. Other GPUs are reserved for passthrough.
#
# Copyright (c) 2015 Assured Information Security, inc.
#   Author: Kyle J. Temkin <temkink@ainfosec.com>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#

#Ensure that only one copy of this script is run at a time.
mkdir /var/lock/discrete_gfx 2> /dev/null || exit 1

#
# Wait for a given device to show up as bound to pciback.
#
function wait_for_pciback() {

  #Get the device's (domain):BDF...
  local BDF=$1
  local timeout=15

  while [ $timeout -gt 0 ]; do

    #Wait one second so the bind can occur...
    sleep 1
    timeout=$(expr $timeout - 1)

    #If we've found that the device is bound to pciback, return.
    if [ -d "/sys/bus/pci/drivers/pciback/$BDF" ]; then
      return 0

    #Otherwise, warn the user and try again.
    else
      echo "Discrete graphics not yet bound to pciback." > /dev/kmsg
      echo "Waiting up to $timeout more seconds." > /dev/kmsg
    fi

  done

  return 1
}

#
# Attempt to bind a given device to pciback, preventing it from being used in dom0.
# Accepts either a (Domain)-BDF, or a sysfs PCI device path.
#
function bind_to_pciback() {

  #Get the device's (domain):BDF...
  local BDF=$1

  #... and use that to bind the device to PCIback.
  echo $BDF > "/sys/bus/pci/drivers/pciback/new_slot"
  echo $BDF > "/sys/bus/pci/drivers/pciback/bind"

}

#First, ensure that Xen's pciback driver has already been loaded.
modprobe xen-pciback 2> /dev/null > /dev/null

#
# Next, we'll need to limit the devices that can bind to to this graphics module,
# so only the Boot VGA is accessible from dom0. The other devices will be reserved
# for passthrough.
#
for device_path in /sys/bus/pci/devices/*; do
  BDF=$(basename $device_path)

  #If this isn't a VGA device, skip it.
  if [[ $(cat "$device_path/class") != 0x0300* ]]; then
    continue
  fi

  #HEURISTIC:
  #If this is our boot VGA, and it's an Intel, we don't ever
  #want to load discrete drivers. Cowardly refuse to load.
  if [ $(cat "$device_path/boot_vga") -eq 1 ]; then
    if [ $(cat "$device_path/vendor") = "0x8086" ]; then
      echo "Cowardly refusing to load discrete graphics when an Intel intergated is present." > /dev/kmsg
      rmdir /var/lock/discrete_gfx
      exit 2
    fi
  fi

  #If this isn't our boot VGA...
  if [ $(cat "$device_path/boot_vga") -eq 0 ]; then

    #... and it's not already bound to pciback...
    if ! [ -d "/sys/bus/pci/drivers/pciback/$BDF" ]; then
      echo "Binding graphics card $BDF to pciback..." > /dev/kmsg

      #... bind it to pciback, effectively reserving it for passthrough.
      bind_to_pciback $BDF

      #Wait for the device to be bound to pciback.
      #If it never appears, bail out!
      wait_for_pciback $BDF || (rmdir /var/lock/discrete_gfx; exit 2)

    fi
  fi

done


#Finally, load the relevant module.
echo "Loading discrete graphics driver." > /dev/kmsg
modprobe --ignore-install $1

rmdir /var/lock/discrete_gfx
