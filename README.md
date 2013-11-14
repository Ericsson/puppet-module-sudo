puppet-module-sudo
==================

Manage sudo package and configuration files in /etc/sudoers.d/

[![Build Status](https://api.travis-ci.org/Ericsson/puppet-module-sudo.png?branch=master)](https://travis-ci.org/Ericsson/puppet-module-sudo)


# Requirements #

Must have at least version 1.7.2 of sudo, which is where `includedir` was introduced.

# Parameters #

package
-------
Package to be installed. Accept string or array.

- *Default*: 'sudo'

package_source
--------------
Source attribute of $package

- *Default*: undef

package_ensure
--------------
Ensure attribute of $package

- *Default*: 'present'

package_manage
--------------
Manage sudo package or not. Accept string or boolean.

- *Default*: 'true'

package_adminfile
-----------------
Path to adminfile for package installation

- *Default*: undef

config_dir
----------
Path to sudoers include dir.

- *Default*: '/etc/sudoers.d'

config_dir_group
----------------
Group attribute of $config_dir

- *Default*: 'root'

config_dir_ensure
-----------------
Ensure attribute of $config_dir

- *Default*: 'present'

config_dir_purge
----------------
Purge attribute of $config_dir

- *Default*: 'true'

sudoers
-------
Hash of sudoers passed to sudo::fragments

- *Default*: undef

sudoers_manage
--------------
Manage $config_file file and files under $config_dir. Accepts string and boolean.

- *Default*: 'false'

config_file
-----------
Path to sudoers file

- *Default*: '/etc/sudoers',

config_file_group
-----------------
Group of $config_file

- *Default*: 'root'

config_file_owner
-----------------
Owner of $config_file

- *Default*: 'root'

config_file_mode
-----------------
Mode of $config_file

- *Default*: '0440'

## sudo::fragment parameters

enusure
-------
Ensure attribute of the file created in $config_dir

- *Default*: present

priority
--------
Priority of the file

- *Default*: 10

content
-------
Content attribute of file

- *Default*: undef

source
------
Source of the file

- *Default*: undef

config_dir
----------
Path to the folder

- *Default*: $sudo::config_dir

config_dir_group
----------------
Group of the file

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

