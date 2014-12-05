# == Define: sudo::fragment
#
define sudo::fragment (
  $ensure           = present,
  $priority         = 10,
  $content          = undef,
  $source           = undef,
  $config_dir       = $sudo::config_dir,
  $tmp_config_dir   = $sudo::tmp_config_dir,
  $config_dir_group = $sudo::config_dir_group,
) {

  file { "tmp_sudoers_file_${name}":
    ensure  => $ensure,
    path    => "${tmp_config_dir}/puppet_verify_sudo_${name}",
    owner   => 'root',
    group   => $config_dir_group,
    mode    => '0440',
    source  => $source,
    content => $content,
    require => File['create_merge_file']
  }

  exec { "merge_all_sudoers_${name}":
    command => "cat ${tmp_config_dir}/puppet_verify_sudo_${name} >> ${tmp_config_dir}/puppet_verify_sudo_merged",
    path    => '/usr/bin:/usr/sbin:/bin',
    require => File["tmp_sudoers_file_${name}"],
  }

  exec { "delete_tmp_sudoers_${name}":
    command => "rm -f ${tmp_config_dir}/puppet_verify_sudo_${name}",
    path    => '/usr/bin:/usr/sbin:/bin',
    require => Exec["merge_all_sudoers_${name}"]
  }


  exec { "verify_sudoers_${name}":
    command => "rm -f ${tmp_config_dir}/puppet_verify_sudo_merged; false",
    path    => '/usr/bin:/usr/sbin:/bin',
    unless  => "visudo -f ${tmp_config_dir}/puppet_verify_sudo_merged -c",
    require => Exec["delete_tmp_sudoers_${name}"],
  }

  file { "${priority}_${name}":
    ensure  => $ensure,
    path    => "${config_dir}/${priority}_${name}",
    owner   => 'root',
    group   => $config_dir_group,
    mode    => '0440',
    source  => $source,
    content => $content,
    require => Exec["verify_sudoers_${name}"],
  }
}

