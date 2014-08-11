# Description

Devstack dev-bed with Vagrant.

It includes:

* multiple providers support (with nested virtualisation activation) [*];
* deb packages cache (after the first build, it will rebuilds more quickly);
* http, https and socks proxy support (socks will be used for git);
* general purpose devstack Chef cookbook.

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

## Enjoy!

Connect to Horizon: `http://192.168.29.4/`


## Notes for libvirt

Because of this bug: https://github.com/pradels/vagrant-libvirt/issues/105, you may want to install the latest version of vagrant-libvirt plugin

```
  ~# vagrant plugin install vagrant-libvirt --plugin-version=0.0.19
```

--

[*] Virtualbox doesn't support nested virtualisation


