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

# VMs definition
machines = {
  'ironic-1' => {
    :box_name => 'trusty64',
    :vcpus => 4,
    :ram => 8192,
    :networks => {
      :openstack => {
        :ip => '192.168.29.4',
        :auto_config => true
      },
      :bm_provision => {
        :ip => '192.168.129.4',
        :auto_config => false
      }
    },
    :nested_virt => true,
    :chef_solo => {
      :recipes => [ 'apt', 'ntp', 'git', 'devstack' ],
      :json => {
        :devstack => {
          :git_repo => '/home/devstack',
          :host_ip => '192.168.29.4',
          :logcolor => true,
          :reclone => false,
          :nova => {
            :virt_driver => 'ironic'
          },
          :ironic  => {
            :baremetal_basic_ops => true,
            :vm_count => 3,
            :vm_specs_cpu => 1,
            :vm_specs_ram => 1024,
            :vm_specs_disk => 10
          },
          :enabled_services => [
            'q-svc', 'q-agt', 'q-dhcp', 'q-l3', 'q-meta', 'neutron',
            'ironic', 'ir-api', 'ir-cond'
          ],
          :disabled_services => [
            'n-net', 'tempest'
          ]
        }
      }
    }
  }
}

VAGRANTFILE_API_VERSION = '2'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Configure plugins
  config.proxy.http = ENV['http_proxy']
  config.proxy.https = ENV['https_proxy']
  config.proxy.no_proxy = ENV['no_proxy']

  config.cache.auto_detect = true
  config.cache.scope = :machine

  config.vm.provider :libvirt do |libvirt|
    libvirt.driver = 'kvm'
    libvirt.uri = 'qemu:///system'
  end

  machines.each_pair do |node_name, node|
    config.vm.define node_name do |server|
      server.vm.hostname = node_name
      server.vm.box = node[:box_name]

      node[:networks].each do |net_name, network|
        server.vm.network :private_network, ip: network[:ip], auto_config: network[:auto_config]
      end


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
