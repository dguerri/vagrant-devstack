#!/bin/bash
#
# Copyright (c) 2014 Davide Guerri <davide.guerri@gmail.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
# implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Vagrant boxes
# Array of "URL;localname;provider"
vagrant_boxes=(
   "https://vagrantcloud.com/parallels/ubuntu-14.04/version/1/provider/parallels.box;trusty64;parallels"
#   "https://vagrantcloud.com/phusion/ubuntu-14.04-amd64/version/2/provider/vmware_fusion.box;trusty64;vmware_fusion"
#   "https://vagrantcloud.com/breqwatr/trusty64/version/1/provider/vmware_desktop.box;trusty64;vmware_desktop"
#   "https://vagrantcloud.com/breqwatr/trusty64/version/1/provider/virtualbox.box;trusty64;virtualbox"
#   "https://vagrantcloud.com/breqwatr/trusty64/version/1/provider/libvirt.box;trusty64;libvirt"
)

# Vagrant plugins
# Space separated list of plugins name
vagrant_plugins=(
   "vagrant-proxyconf"
   "vagrant-cachier"
   "vagrant-libvirt"
   "vagrant-parallels"
)

# Setup basedir and cookbooksdir
pushd $(dirname $0) > /dev/null
basedir=$(pwd)

function install_cookbooks() {
  echo "*** Cloning cookbooks"

  git submodule update --init
  git submodule
}

function install_vagrant_boxes() {
  local boxes=$@

  echo "*** Installing vagrant boxes"

  for box in $boxes; do
    local remote_name=$(echo "$box"|cut -d';' -f1)
    local local_name=$(echo "$box"|cut -d';' -f2)
    local provider=$(echo "$box"|cut -d';' -f3)

    if [ -z "$(vagrant box list|grep $local_name|grep $provider)" ]; then
       echo "Adding '$remote_name' $provider box"
       vagrant box add $local_name $remote_name >/dev/null
       if [ $? -ne 0 ]; then
         echo "Failed to download '$remote_name' virtualbox box"
         exit 1
       fi
    else
      echo "Box '$local_name' for '$provider' is already installed"
    fi
  done
}

function install_vagrant_plugins() {
  local plugins=$@
  local installed_plugins=$(vagrant plugin list)

  echo "*** Installing vagrant plugins"

  for plugin in $plugins; do
    if [ -z "$(echo $installed_plugins|grep $plugin)" ]; then
      echo "Installing '$plugin' plugin"
      vagrant plugin install $plugin >/dev/null
      if [ $? -ne 0 ]; then
        echo "Failed to install '$plugin' plugin!"
        exit 1
      fi
    else
      echo "Plugin '$plugin' already installed"
    fi
  done
}

vagrant destroy -f >/dev/null 2>&1

install_cookbooks $cookbooks
install_vagrant_boxes "${vagrant_boxes[@]}"
install_vagrant_plugins "${vagrant_plugins[@]}"

popd > /dev/null

echo -e "\nNow run $basedir/rebuild.sh !"

