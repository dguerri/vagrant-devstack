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
require 'uri'

git_repo = node[:devstack][:git_repo]

# Install requireed pachages
# TODO: split packages by requiring service (nova, ironic, ...) and install
# them only if needed
%w{qemu-kvm libvirt-bin python-libvirt socat syslinux avahi-daemon xinetd tftpd-hpa}.each do |pkg|
  package pkg do
    action :install
  end
end

# Install optional packages
%w(htop virt-viewer).each do |pkg|
  package pkg do
    action :install
  end
end

use_proxy = !node[:devstack][:socks_proxy].nil? || !node[:devstack][:https_proxy].nil?

# Setup proxy wrapper for git (root user)
if use_proxy

  template '/usr/local/bin/git_proxy_wrapper.sh' do
    source 'git_proxy_wrapper.sh.erb'
    variables({
      :socks_proxy_hostname => URI(node[:devstack][:socks_proxy]||'').hostname,
      :socks_proxy_port => URI(node[:devstack][:socks_proxy]||'').port,
      :https_proxy_hostname => URI(node[:devstack][:https_proxy]||'').hostname,
      :https_proxy_port => URI(node[:devstack][:https_proxy]||'').port
    })
    mode 0775
    owner 'root'
    group 'root'
  end


  execute 'configure_git_wrapper' do
    command "git config -f /root/.gitconfig core.gitproxy '/usr/local/bin/git_proxy_wrapper.sh'"
    user 'root'
    group 'root'
    not_if 'git config -f /opt/stack/.gitconfig core.gitproxy'
  end

end

# Clone DevStack
git "#{git_repo}" do
  repository 'https://github.com/openstack-dev/devstack.git'
  reference 'master'
  action :checkout
end

template "#{git_repo}/local.conf" do
  source 'local.conf.erb'
end

execute 'create_stackuser' do
  command "#{git_repo}/tools/create-stack-user.sh"
  not_if 'id stack'
end

# Setup proxy wrapper for git (root user)
if use_proxy

  execute 'configure_git_wrapper' do
    command "git config -f /opt/stack/.gitconfig core.gitproxy '/usr/local/bin/git_proxy_wrapper.sh'"
    user 'stack'
    group 'stack'
    not_if 'git config -f /opt/stack/.gitconfig core.gitproxy'
  end

end

execute 'set_permission' do
  command "chown -R stack:stack #{git_repo}"
  not_if "stat #{git_repo} | grep 'Uid: ( 1001/   stack)'"
end

# Stack it!
log 'Executing stack.sh. This will take a while...' do
  level :info
end

script 'exec_stack' do
  interpreter 'bash'
  cwd "#{git_repo}"
  #user 'stack'
  environment 'HOME' => '/opt/stack'
  code 'su stack -c ./stack.sh'
  not_if { ::File.exists?("#{git_repo}/stack-screenrc") }
end
