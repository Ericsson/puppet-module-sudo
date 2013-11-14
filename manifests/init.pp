# == Class: sudo
#
# Module to manage sudoers and sudo package
#
class sudo (
  $package           = 'sudo',
  $package_source    = undef,
  $package_ensure    = 'present',
  $package_manage    = 'true',
  $package_adminfile = undef,
  $config_dir        = '/etc/sudoers.d',
  $config_dir_group  = 'root',
  $config_dir_ensure = 'present',
  $config_dir_purge  = 'true',
  $sudoers           = undef,
  $sudoers_manage    = 'false',
) {

  if type($package_manage) == 'string' {
    $package_manage_real = str2bool($package_manage)
  } else {
    $package_manage_real = $package_manage
  }
  if type($sudoers_manage) == 'string' {
    $sudoers_manage_real = str2bool($sudoers_manage)
  } else {
    $sudoers_manage_real = $sudoers_manage
  }
  if type($config_dir_purge) == 'string' {
    $config_dir_purge_real = str2bool($config_dir_purge)
  } else {
    $config_dir_purge_real = $config_dir_purge
  }

  # Validate params
  validate_bool($package_manage_real)
  validate_bool($sudoers_manage_real)
  validate_bool($config_dir_purge_real)
  validate_absolute_path($config_dir)
  if $package_adminfile != undef {
    validate_absolute_path($package_adminfile)
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
    file { $config_dir:
      ensure  => $config_dir_ensure,
      owner   => 'root',
      group   => $config_dir_group,
      mode    => '0550',
      recurse => $config_dir_purge_real,
      purge   => $config_dir_purge_real,
    }

    # Only works with sudo >= 1.7.2
    if $sudoers != undef {
      create_resources('sudo::fragment',$sudoers)
    }
  }
}
