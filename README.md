puppet-module-sudo
==================

Manage sudo package and configuration files in /etc/sudoers.d/

[![Build Status](https://api.travis-ci.org/Ericsson/puppet-module-sudo.png?branch=master)](https://travis-ci.org/Ericsson/puppet-module-sudo)


# Requirements #

Must have at least version 1.7.2 of sudo, which is where `includedir` was introduced.


# Compatability #

This module has been tested to work on the following systems with the latest
Puppet v3, v3 with future parser, v4, v5 and v6. See `.travis.yml` for the
exact matrix of supported Puppet and ruby versions.

## OS Distributions ##

 * Debian 7
 * Debian 8
 * EL 5
 * EL 6
 * EL 7
 * SLED 10
 * SLED 11
 * SLED 12
 * SLES 10
 * SLES 11
 * SLES 12
 * Solaris 9
 * Solaris 10
 * Solaris 11
 * Ubuntu 12.04 LTS
 * Ubuntu 14.04 LTS
 * Ubuntu 16.04 LTS


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

config_dir_mode
---------------
Mode attribute of $config_dir

- *Default*: '0750'

config_dir_ensure
-----------------
Ensure attribute of $config_dir

- *Default*: 'directory'

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

- *Default*: 'true'

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

requiretty
----------
Enable requiretty option in sudoers file

- *Default*: 'true'

visiblepw
---------
Enable visiblepw option in sudoers file

- *Default*: 'false'

always_set_home
---------------
Enable always_set_home option in sudoers file

- *Default*: 'true'

envreset
--------
Enable envreset option in sudoers file

- *Default*: 'true'

envkeep
-------
Array of environment variables for envkeep option in sudoers file

- *Default*: ['COLORS','DISPLAY','HOSTNAME','HISTSIZE','INPUTRC','KDEDIR','LS_COLORS','MAIL','PS1','PS2','QTDIR','USERNAME','LANG','LC_ADDRESS','LC_CTYPE','LC_COLLATE','LC_IDENTIFICATION','LC_MEASUREMENT','LC_MESSAGES','LC_MONETARY','LC_NAME','LC_NUMERIC','LC_PAPER','LC_TELEPHONE','LC_TIME','LC_ALL','LANGUAGE','LINGUAS','_XKB_CHARSET','XAUTHORITY']

secure_path
-----------
String of secure path in sudoers file

- *Default*: '/sbin:/bin:/usr/sbin:/usr/bin'

root_allow_all
--------------
Enable sudo rule in sudoers file for root to get full access

- *Default*: 'true'

includedir
----------
Enable inclusion of fragments directory in sudoers file. Requires sudo >= 1.7.2

- *Defaults*: 'true'

include_libsudo_vas
-------------------
Enable inclusion of libsudo_vas plugin. Requires sudo >= 1.8

- *Defaults*: 'false'

libsudo_vas_location
--------------------
Location of libsudo_vas plugin

- *Defaults*: 'USE_DEFAULTS', based on architecture

always_query_group_plugin
-------------------------
Sets Defaults option 'always_query_group_plugin'. Previously all unknown system
groups was automatically passed to the group plugin. This is no longer the case
since 1.8.15. To pass unknown system groups to group_plugin 'always_query_group_plugin'
must be set.

Sudo lines with the syntax below will always use group_plugin to resolve groups.
plugin for that specific entry:
<pre>
%:Group
</pre>

- *Defaults*: 'USE_DEFAULTS'

This option is automatically enabled if include_libsudo_vas is set to true and
$::sudo_version => 1.8.15.

## sudo::fragment parameters

ensure
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
    content : "%admins ALL=(ALL) NOPASSWD: ALL"
  "userX":
    content : "USERX ALL=(ALL) ALL"
</pre>
