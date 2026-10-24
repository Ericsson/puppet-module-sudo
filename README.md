# puppet-module-sudo

#### Table of Contents

1. [Module Description - What the module does and why it is useful](#module-description)
1. [Setup - The basics of getting started with sudo](#setup)
   * [What sudo affects](#what-sudo-affects)
   * [Beginning with sudo](#beginning-with-sudo)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - Parameter reference](#reference)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Module description

This module manages the sudo package, the main `/etc/sudoers` file and
configuration fragments in `/etc/sudoers.d/`.

## Setup

### What sudo affects

* The sudo package (optional, see `package_manage`).
* `/etc/sudoers`, rendered from the module's EPP template.
* The `/etc/sudoers.d/` directory. By default it is purged, so any fragment
  not managed by Puppet is removed (see `config_dir_purge`).

### Beginning with sudo

Include the main `sudo` class. The defaults give a working `/etc/sudoers`
that includes `/etc/sudoers.d/`.

```puppet
include sudo
```

## Usage

### Manage sudo rules through Hiera

Each entry in `sudo::sudoers` becomes a `sudo::fragment`, written to
`/etc/sudoers.d/<priority>_<name>`:

```yaml
sudo::sudoers:
  'admins':
    content: '%admins ALL=(ALL) NOPASSWD: ALL'
  'userX':
    content: 'USERX ALL=(ALL) ALL'
```

### Manage a single fragment

```puppet
sudo::fragment { 'backup':
  priority => 20,
  content  => 'backup ALL=(root) NOPASSWD: /usr/local/bin/backup.sh',
}
```

### Quest/One Identity VAS group lookups

Set `include_libsudo_vas` to load the libsudo_vas group plugin. When the
`sudo_version` fact is 1.8.15 or newer, `always_query_group_plugin` is then
enabled automatically, so unknown system groups are resolved through the
plugin.

## Reference

This module is documented via [puppet-strings](https://github.com/puppetlabs/puppet-strings).
See [REFERENCE.md](REFERENCE.md) for the full list of classes, defined types
and all of their parameters.

## Limitations

This module supports Puppet 8 (see `metadata.json` for the exact requirement).
It is tested against the operating systems listed below. The supported OS
matrix is defined in `metadata.json`, and CI runs `pdk validate` and
`pdk test unit` on Puppet 8 via GitHub Actions (see `.github/workflows/`).

 * Debian 11, 12
 * RedHat (EL) 7, 8, 9, 10
 * Rocky 8, 9, 10
 * SLES 12, 15
 * Ubuntu 20.04, 22.04, 24.04

Other operating systems might be supported by configuring the module with
the correct parameters.

## Development

Contributions are welcome. This module is managed with
[PDK](https://www.puppet.com/docs/pdk). Before submitting changes, run the
validators and unit tests:

```bash
pdk validate
pdk test unit
```

Please keep `REFERENCE.md` in sync by regenerating it from the class
documentation when parameters change:

```bash
pdk bundle exec puppet strings generate --format markdown
```
