# Description

Devstack dev-bed with Vagrant.

It includes:

* multiple providers support (libvirt, parallels, vmware_{desktop, fusion}, virtualbox) [*];
* deb packages cache (after the first build, it will rebuilds more quickly);
* http, https and socks proxy support (with automatic detection *);
* general purpose devstack Chef cookbook.

(*) If the environment variable socks_proxy is defined, its value will be used to configure a proxy for git.
If socks_proxy is not defined and https_proxy is defined, git will be configure to use the latter (use it only if your proxy allows CONNECT).

# Usage

## Configure

The default provider is Parallels, you may want to edit `setup.sh` in order to configure the desired provider, box and plugin and `rebuild.sh` to configure the desired provider.

## Setup

First time (usually right after cloning this repository from Github)

```
  ~# ./setup.sh
```

## (Re)build

```
  ~# ./rebuild.sh
```

VMs are defined using json (e.g., see machines.json)
By default VMs definition is loaded from `machines.json`, it is possible to specify an alternate configuration file using the `VD_CONFIGURATION_FILE` environment variable:

```
  ~# VD_CONFIGURATION_FILE="ironic-bmnet.json" ./rebuild.sh
  ~# VD_CONFIGURATION_FILE="ironic-bmnet.json" vagrant status
```

## Enjoy!

Connect to Horizon: `http://192.168.29.4/`


## Notes for libvirt

Because of this bug: https://github.com/pradels/vagrant-libvirt/issues/105, you may want to install the latest version of vagrant-libvirt plugin

```
  ~# vagrant plugin install vagrant-libvirt --plugin-version=0.0.19
```

--

[*] Virtualbox doesn't support nested virtualisation


