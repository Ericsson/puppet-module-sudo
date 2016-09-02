# == Define: sudo::fragment
#
define sudo::fragment (
  $ensure           = present,
  $priority         = 10,
  $content          = undef,
  $source           = undef,
  $config_dir       = $sudo::config_dir,
  $config_dir_group = $sudo::config_dir_group,
) {

  $content_real = $content ? {
    undef   => undef,
    default => "${content}\n"
  }

  file { "${priority}_${name}":
    ensure  => $ensure,
    path    => "${config_dir}/${priority}_${name}",
    owner   => 'root',
    group   => $config_dir_group,
    mode    => '0440',
    source  => $source,
    content => $content_real,
  }
}
