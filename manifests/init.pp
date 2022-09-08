# Manage sudo package and configuration files in /etc/sudoers.d/
#
# @param package
#   Package to be installed. Accept string or array.
#
# @param package_source
#   Source attribute of $package.
#
# @param package_ensure
#   Ensure attribute of $package.
#
# @param package_manage
#   Manage sudo package or not.
#
# @param package_adminfile
#   Path to adminfile for package installation.
#
# @param config_dir
#   Path to sudoers include dir.
#
# @param config_dir_group
#   Group attribute of $config_dir.
#
# @param config_dir_mode
#   Mode attribute of $config_dir.
#
# @param config_dir_ensure
#   Ensure attribute of $config_dir.
#
# @param config_dir_purge
#   Purge attribute of $config_dir.
#
# @param sudoers
#   Hash of sudoers passed to sudo::fragments.
#
# @param sudoers_manage
#   Manage $config_file file and files under $config_dir.
#
# @param config_file
#   Path to sudoers file.
#
# @param config_file_group
#   Group of $config_file.
#
# @param config_file_owner
#   Owner of $config_file.
#
# @param config_file_mode
#   Mode of $config_file.
#
# @param requiretty
#   Enable requiretty option in sudoers file.
#
# @param visiblepw
#   Enable visiblepw option in sudoers file.
#
# @param always_set_home
#   Enable always_set_home option in sudoers file.
#
# @param envreset
#   Enable envreset option in sudoers file.
#
# @param envkeep
#   Array of environment variables for envkeep option in sudoers file.
#
# @param secure_path
#   String of secure path in sudoers file.
#
# @param root_allow_all
#   Enable sudo rule in sudoers file for root to get full access.
#
# @param includedir
#   Enable inclusion of fragments directory in sudoers file. Requires sudo >= 1.7.2.
#
# @param include_libsudo_vas
#   Enable inclusion of libsudo_vas plugin. Requires sudo >= 1.8.
#
# @param libsudo_vas_location
#   Location of libsudo_vas plugin
#
# @param always_query_group_plugin
#   Sets Defaults option 'always_query_group_plugin'. Previously all unknown system
#   groups was automatically passed to the group plugin. This is no longer the case
#   since 1.8.15. To pass unknown system groups to group_plugin 'always_query_group_plugin'
#   must be set.
#
#   Sudo lines with the syntax below will always use group_plugin to resolve groups.
#   plugin for that specific entry:
#   <pre>
#   %:Group
#   </pre>
#
#   This option is automatically enabled if include_libsudo_vas is set to true and
#   $::sudo_version => 1.8.15.
#
# @param hiera_merge_sudoers
#   TODO: missing documentation
#
class sudo (
  Variant[Array, String[1]]                      $package                   = 'sudo',
  Optional[String[1]]                            $package_source            = undef,
  Enum['present','absent']                       $package_ensure            = 'present',
  Boolean                                        $package_manage            = true,
  Optional[Stdlib::Absolutepath]                 $package_adminfile         = undef,
  Stdlib::Absolutepath                           $config_dir                = '/etc/sudoers.d',
  String[1]                                      $config_dir_group          = 'root',
  Stdlib::Filemode                               $config_dir_mode           = '0750',
  Enum['present', 'absent', 'directory', 'link'] $config_dir_ensure         = 'directory',
  Boolean                                        $config_dir_purge          = true,
  Optional[Hash]                                 $sudoers                   = undef,
  Boolean                                        $sudoers_manage            = true,
  Stdlib::Absolutepath                           $config_file               = '/etc/sudoers',
  String[1]                                      $config_file_group         = 'root',
  String[1]                                      $config_file_owner         = 'root',
  Stdlib::Filemode                               $config_file_mode          = '0440',
  Boolean                                        $requiretty                = true,
  Boolean                                        $visiblepw                 = false,
  Boolean                                        $always_set_home           = true,
  Boolean                                        $envreset                  = true,
  Array                                          $envkeep                   = ['COLORS','DISPLAY','HOSTNAME','HISTSIZE','INPUTRC','KDEDIR','LS_COLORS','MAIL','PS1','PS2','QTDIR','USERNAME','LANG','LC_ADDRESS','LC_CTYPE','LC_COLLATE','LC_IDENTIFICATION','LC_MEASUREMENT','LC_MESSAGES','LC_MONETARY','LC_NAME','LC_NUMERIC','LC_PAPER','LC_TELEPHONE','LC_TIME','LC_ALL','LANGUAGE','LINGUAS','_XKB_CHARSET','XAUTHORITY'], #lint:ignore:140chars
  String[1]                                      $secure_path               = '/sbin:/bin:/usr/sbin:/usr/bin',
  Boolean                                        $root_allow_all            = true,
  Boolean                                        $includedir                = true,
  Boolean                                        $include_libsudo_vas       = false,
  String[1]                                      $libsudo_vas_location      = 'USE_DEFAULTS',
  String[1]                                      $always_query_group_plugin = 'USE_DEFAULTS',
  Boolean                                        $hiera_merge_sudoers       = false,
) {
  if is_string($package_manage) {
    $package_manage_real = str2bool($package_manage)
  } else {
    $package_manage_real = $package_manage
  }
  if is_string($sudoers_manage) {
    $sudoers_manage_real = str2bool($sudoers_manage)
  } else {
    $sudoers_manage_real = $sudoers_manage
  }
  if is_string($config_dir_purge) {
    $config_dir_purge_real = str2bool($config_dir_purge)
  } else {
    $config_dir_purge_real = $config_dir_purge
  }
  if is_string($requiretty) {
    $requiretty_real = str2bool($requiretty)
  } else {
    $requiretty_real = $requiretty
  }
  if is_string($visiblepw) {
    $visiblepw_real = str2bool($visiblepw)
  } else {
    $visiblepw_real = $visiblepw
  }
  if is_string($always_set_home) {
    $always_set_home_real = str2bool($always_set_home)
  } else {
    $always_set_home_real = $always_set_home
  }
  if is_string($envreset) {
    $envreset_real = str2bool($envreset)
  } else {
    $envreset_real = $envreset
  }
  if is_string($root_allow_all) {
    $root_allow_all_real = str2bool($root_allow_all)
  } else {
    $root_allow_all_real = $root_allow_all
  }
  if is_string($includedir) {
    $includedir_real = str2bool($includedir)
  } else {
    $includedir_real = $includedir
  }
  if is_string($include_libsudo_vas) {
    $include_libsudo_vas_real = str2bool($include_libsudo_vas)
  } else {
    $include_libsudo_vas_real = $include_libsudo_vas
  }

  if is_string($hiera_merge_sudoers) {
    $hiera_merge_sudoers_bool = str2bool($hiera_merge_sudoers)
  } else {
    $hiera_merge_sudoers_bool = $hiera_merge_sudoers
  }

  # Validate params
  validate_bool($package_manage_real)
  validate_bool($sudoers_manage_real)
  validate_bool($config_dir_purge_real)
  validate_bool($requiretty_real)
  validate_bool($visiblepw_real)
  validate_bool($always_set_home_real)
  validate_bool($envreset_real)
  validate_bool($root_allow_all_real)
  validate_bool($includedir_real)
  validate_bool($include_libsudo_vas_real)
  validate_bool($hiera_merge_sudoers_bool)
  validate_absolute_path($config_dir)
  validate_absolute_path($config_file)
  if $package_adminfile != undef {
    validate_absolute_path($package_adminfile)
  }
  if $sudoers_manage_real == true {
    validate_array($envkeep)
    validate_string($secure_path)
  }
  # Only works with sudo >= 1.8
  if $libsudo_vas_location == 'USE_DEFAULTS' {
    if $facts['os']['architecture'] =~ /amd64|x86_64/ {
      $libsudo_vas_location_real = '/opt/quest/lib64/libsudo_vas.so'
    } else {
      $libsudo_vas_location_real = '/opt/quest/lib/libsudo_vas.so'
    }
  } else {
    $libsudo_vas_location_real = $libsudo_vas_location
  }
  if $include_libsudo_vas_real == true {
    validate_absolute_path($libsudo_vas_location_real)
  }

  # Sudo 1.8.15 introduced a new Defaults option 'always_query_group_plugin'.
  # This option is required in >= 1.8.15 if you want sudo to automatically do
  # lookups through group_plugins.
  if $always_query_group_plugin == 'USE_DEFAULTS' {
    if (versioncmp("${facts['sudo_version']}", '1.8.15') >= 0) and $include_libsudo_vas_real == true { # lint:ignore:only_variable_string
      $always_query_group_plugin_real = true
    } else {
      $always_query_group_plugin_real = false
    }
  } else {
    $always_query_group_plugin_real = $always_query_group_plugin
  }

  if $package_manage_real == true {
    package { 'sudo-package':
      ensure    => $package_ensure,
      name      => $package,
      source    => $package_source,
      adminfile => $package_adminfile,
    }
  }

  if $sudoers_manage_real == true {
    file { $config_file:
      owner   => $config_file_owner,
      group   => $config_file_group,
      mode    => $config_file_mode,
      content => template('sudo/sudoers.erb'),
    }
    file { $config_dir:
      ensure  => $config_dir_ensure,
      owner   => 'root',
      group   => $config_dir_group,
      mode    => $config_dir_mode,
      recurse => $config_dir_purge_real,
      purge   => $config_dir_purge_real,
    }

    # Only works with sudo >= 1.7.2
    if $sudoers != undef {
      if $hiera_merge_sudoers_bool {
        $sudoers_real = hiera_hash(sudo::sudoers)
      } else {
        $sudoers_real = $sudoers
      }
      validate_hash($sudoers_real)
      create_resources('sudo::fragment',$sudoers_real)
    }
  }
}
