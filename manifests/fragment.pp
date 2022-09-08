# Define to manage configuration files in /etc/sudoers.d/
#
# @param ensure
#   Ensure attribute of the file created in $config_dir.
#
# @param priority
#   Priority of the file.
#
# @param content
#   Content attribute of file.
#
# @param source
#  Source of the file.
#
# @param config_dir
#   Path to the folder.
#
# @param config_dir_group
#   Group of the file.
#
define sudo::fragment (
  Enum['present','absent']     $ensure           = 'present',
  Integer                      $priority         = 10,
  Optional[String[1]]          $content          = undef,
  Optional[Stdlib::Filesource] $source           = undef,
  Stdlib::Absolutepath         $config_dir       = $sudo::config_dir,
  String[1]                    $config_dir_group = $sudo::config_dir_group,
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
