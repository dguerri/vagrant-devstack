# Description

Devstack dev-bed with Vagrant.

It includes:

* multiple providers support (with nested virtualisation activation) [*];
* general purpose devstack Chef cookbook;
* http, https and socks proxy support.

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

--

[*] Virtualbox doesn't support nested virtualisation.
