# Description

Devstack dev-bed with Vagrant.

It includes:

* multiple providers support (libvirt, parallels, vmware_{desktop, fusion}, virtualbox) [*];
* deb packages cache (after the first build, it will rebuilds more quickly);
* http, https and socks proxy support (with automatic detection [**]);
* general purpose devstack Chef cookbook.

# Usage

## Configure

Use the `VAGRANT_DEFAULT_PROVIDER` environment variable to the desired provider

_E.g._:
```
  ~# export VAGRANT_DEFAULT_PROVIDER=parallels
  ~# ./rebuild.sh
```

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
  ~# export VD_CONFIGURATION_FILE="ironic-bmnet.json"
  ~# export VAGRANT_DEFAULT_PROVIDER=parallels
  ~# ./rebuild.sh
[...]
  ~# vagrant status
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

[**] If the environment variable `socks_proxy` is defined, its value will be used to configure a proxy for git.
If `socks_proxy` is not defined and `https_proxy` is defined, git will be configure to use the latter (use it only if your proxy allows CONNECT).

