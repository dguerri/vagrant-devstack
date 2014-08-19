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

# Proxy
default[:devstack][:http_proxy] = ENV['http_proxy']
default[:devstack][:https_proxy] = ENV['https_proxy']
default[:devstack][:no_proxy] = ENV['no_proxy']
# not standard...
default[:devstack][:socks_proxy] = ENV['socks_proxy']

# Directory for git clone
default[:devstack][:git_repo] = '/root/devstack'

# Variables used in devstack/localrc
default[:devstack][:dest] = '/opt/stack'
default[:devstack][:enabled_services] = []
default[:devstack][:disabled_services] = []
default[:devstack][:admin_password] = 'pass'
default[:devstack][:mysql_password] = 'pass'
default[:devstack][:rabbit_password] = 'pass'
default[:devstack][:service_password] = 'pass'
default[:devstack][:service_token] = 'servtoken'
default[:devstack][:host_ip] = '127.0.0.1'
default[:devstack][:logfile] = 'stack.sh.log'
default[:devstack][:logdays] = '1'
default[:devstack][:log_color] = false
default[:devstack][:screen_logdir] = '/opt/stack/logs/screen'
default[:devstack][:api_rate_limit] = false
default[:devstack][:apt_fast] = true
default[:devstack][:reclone] = true
default[:devstack][:image_urls] = []
# Nova
default[:devstack][:nova][:repo] = ''
default[:devstack][:nova][:branch] = ''
default[:devstack][:nova][:virt_driver] = ''
# Neutron
default[:devstack][:neutron][:repo] = ''
default[:devstack][:neutron][:branch] = ''
default[:devstack][:neutron][:physical_network] = ''
default[:devstack][:neutron][:ovs_physical_bridge] = ''
default[:devstack][:neutron][:public_interface] = ''
default[:devstack][:neutron][:dhcp_first_address] = ''
default[:devstack][:neutron][:dhcp_last_address] = ''
default[:devstack][:neutron][:fixed_range] = ''
default[:devstack][:neutron][:network_gateway] = ''
# Heat
default[:devstack][:heat][:repo] = ''
default[:devstack][:heat][:branch] = ''
# Ironic
default[:devstack][:ironic][:repo] = ''
default[:devstack][:ironic][:branch] = ''
default[:devstack][:ironic][:basic_ops] = false
default[:devstack][:ironic][:vm_count] = 0
default[:devstack][:ironic][:vm_specs_cpu] = ''
default[:devstack][:ironic][:vm_specs_ram] = ''
default[:devstack][:ironic][:vm_specs_disk] = ''
default[:devstack][:ironic][:build_deploy_ramdisk] = true

default[:devstack][:ironic][:bm_external_interface] = nil
# Glance
default[:devstack][:glance][:repo] = ''
default[:devstack][:glance][:branch] = ''
# Cinder
default[:devstack][:cinder][:repo] = ''
default[:devstack][:cinder][:branch] = ''
