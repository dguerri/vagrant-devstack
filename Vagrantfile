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

require 'json'
require 'optparse'

configuration_file = ENV['VD_CONFIGURATION_FILE'] || 'machines.json'

# Load VMs definitions
machines = JSON.load(File.new(configuration_file))

use_proxy = !(ENV['http_proxy'].nil? || ENV['https_proxy'].nil?) ||
            !(ENV['http_proxy'].empty? || ENV['https_proxy'].empty?)

VAGRANTFILE_API_VERSION = '2'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Configure plugins
  if use_proxy
    config.proxy.http = ENV['http_proxy']
    config.proxy.https = ENV['https_proxy']
    config.proxy.no_proxy = ENV['no_proxy']
  end

  config.cache.auto_detect = true
  config.cache.scope = :machine

  config.vm.provider :libvirt do |libvirt|
    libvirt.driver = 'kvm'
    libvirt.uri = 'qemu:///system'
  end

  machines.each_pair do |node_name, node|

    config.vm.define node_name do |server|
      server.vm.hostname = node_name
      server.vm.box = node['box_name']

      node['networks'].each do |net_name, network|
        server.vm.network network.fetch('type', :private_network),
                          ip: network['ip'],
                          mac: node['mac'],
                          auto_config: network['auto_config']

        # Never use proxy for local addresses
        # This is strictly needed by neutron metadata proxy and Ironic API
        # server (actually, it would be sufficient to add only the devstack
        # HOST_IP address to no_proxy)
        if use_proxy and network['ip']
          config.proxy.no_proxy += ",#{network['ip']}"
        end
      end


      # Provider specific settings
      %w(parallels virtualbox libvirt vmware_fusion).each do |provider|
        server.vm.provider provider do |config|
          config.memory = node['ram']
          config.cpus = node['vcpus']

          if node['nested_virt']
            config.vmx['vhv.enable'] = 'TRUE' if provider == 'vmware_fusion'
            config.nested = true if provider == 'libvirt'
            config.customize [
              'set', :id, '--nested-virt', 'on'
            ] if provider == 'parallels'
          end
        end
      end

      # Chef solo provisioning
      if node['chef_solo']
        server.vm.provision :chef_solo do |chef|
          node['chef_solo']['recipes'].each {|recipe| chef.add_recipe recipe}

          chef.json = node['chef_solo']['json'] || {}
        end
      end
    end

  end

end
