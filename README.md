puppet-module-sudo
==================

Manage sudo package and configuration files in /etc/sudoers.d/

[![Build Status](https://api.travis-ci.org/Ericsson/puppet-module-sudo.png?branch=master)](https://travis-ci.org/Ericsson/puppet-module-sudo)


# Requirements #

Must have at least version 1.7.2 of sudo, which is where `includedir` was introduced.

# Parameters #

package
-------
Name of the sudo package

- *Default*: 'sudo'

package_source
--------------

- *Default*: undef

package_ensure
--------------

- *Default*: 'present'

package_manage
--------------

- *Default*: 'true'

package_adminfile
-----------------

- *Default*: undef

config_dir
----------

- *Default*: '/etc/sudoers.d'

config_dir_group
----------------

- *Default*: 'root'

config_dir_ensure
-----------------

- *Default*: 'present'

config_dir_purge
----------------

- *Default*: 'true'

sudoers
-------

- *Default*: undef

## sudo::fragment parameters

enusure
-------

- *Default*: present

priority
--------

- *Default*: 10

content
-------

- *Default*: undef

source
------

- *Default*: undef

config_dir
----------

- *Default*: $sudo::config_dir

config_dir_group
----------------

- *Default*: $sudo::config_dir_group

# Sample usage:
 sudo for group admins and user userX through Hiera.

<pre>
sudo::sudoers:
  "admins":
    content : "%admins ALL=(ALL) NOPASSWD: ALL\n"
  "userX":
    content : "USERX ALL=(ALL) ALL\n"
</pre>

