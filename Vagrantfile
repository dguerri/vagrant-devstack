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

require './utils/hp_proxy'

# Proxy support
$hp_proxy.enabled = :auto

# VMs definition
boxes = {
  'ironic-1' => {
    :vcpus => 4,
    :ram => 4096,
    :ip => '192.168.29.4',
    :box_name => 'trusty64',
    :nested_virt => true,
    :chef_solo => {
      :recipes => [ 'apt', 'ntp', 'git', 'devstack' ],
      :json => {
        :devstack => {
          :use_proxy => $hp_proxy.enabled,
          :socks_proxy_hostname => $hp_proxy.socks,
          :socks_proxy_port => $hp_proxy.socks_port,
          :git_repo => '/home/devstack',
          :host_ip => '192.168.29.4',
          :logcolor => true,
          :reclone => false,
          :enabled_services => [
            'heat', 'h-api', 'h-api-cfn', 'h-api-cw', 'h-eng',
            'q-lbaas', 'q-svc', 'q-agt', 'q-dhcp', 'q-l3', 'q-meta', 'neutron'
          ],
          :disabled_services => [
            'n-net'
          ]
        }
      }
    }
  }
}

VAGRANTFILE_API_VERSION = '2'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Configure plugins
  $hp_proxy.setup(config)

  config.cache.auto_detect = true
  config.cache.scope = :machine

  config.vm.provider :libvirt do |libvirt|
    libvirt.driver = 'qemu'
    libvirt.uri = 'qemu:///system'
  end

  boxes.each_pair do |node_name, node|
    config.vm.define node_name do |server|
      server.vm.hostname = node_name
      server.vm.box = node[:box_name]

      server.vm.network :private_network, ip: node[:ip] if node[:ip]

      # Provider specific settings
      %w(parallels virtualbox libvirt vmware_fusion).each do |provider|
        server.vm.provider provider do |config|
          config.memory = node[:ram]
          config.cpus = node[:vcpus]

          if node[:nested_virt]
            config.vmx['vhv.enable'] = 'TRUE' if provider == 'vmware_fusion'
            config.nested = true if provider == 'libvirt'
            config.customize ['set', :id, '--nested-virt', 'on'] if provider == 'parallels'
          end
        end
      end

      # Chef solo provisioning
      if node[:chef_solo]
        server.vm.provision :chef_solo do |chef|
          node[:chef_solo][:recipes].each {|recipe| chef.add_recipe recipe}

          chef.json = node[:chef_solo][:json] || {}
        end
      end
    end

  end

end
