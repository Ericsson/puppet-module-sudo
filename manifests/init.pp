# == Class: sudo
#
# Module to manage sudoers and sudo package
#
class sudo (
  $package              = 'sudo',
  $package_source       = undef,
  $package_ensure       = 'present',
  $package_manage       = 'true',
  $package_adminfile    = undef,
  $config_dir           = '/etc/sudoers.d',
  $config_dir_group     = 'root',
  $config_dir_mode      = '0750',
  $config_dir_ensure    = 'directory',
  $config_dir_purge     = 'true',
  $sudoers              = undef,
  $sudoers_manage       = 'true',
  $config_file          = '/etc/sudoers',
  $config_file_group    = 'root',
  $config_file_owner    = 'root',
  $config_file_mode     = '0440',
  $requiretty           = 'true',
  $visiblepw            = 'false',
  $always_set_home      = 'true',
  $envreset             = 'true',
  $envkeep              = ['COLORS','DISPLAY','HOSTNAME','HISTSIZE','INPUTRC','KDEDIR','LS_COLORS','MAIL','PS1','PS2','QTDIR','USERNAME','LANG','LC_ADDRESS','LC_CTYPE','LC_COLLATE','LC_IDENTIFICATION','LC_MEASUREMENT','LC_MESSAGES','LC_MONETARY','LC_NAME','LC_NUMERIC','LC_PAPER','LC_TELEPHONE','LC_TIME','LC_ALL','LANGUAGE','LINGUAS','_XKB_CHARSET','XAUTHORITY'],
  $secure_path          = '/sbin:/bin:/usr/sbin:/usr/bin',
  $root_allow_all       = 'true',
  $includedir           = 'true',
  $include_libsudo_vas  = 'false',
  $libsudo_vas_location = 'USE_DEFAULTS',
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
    if $::architecture =~ /amd64|x86_64/ {
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
      validate_hash($sudoers)
      create_resources('sudo::fragment',$sudoers)
    }
  }
}
