#
define foreman_bootstrap::virt_install(
  $ensure             = 'present',
  $domain             = 'localdomain',
  $certname           = "${name}.${domain}",
  $hostname           = "${name}.${domain}",
  $ks_url             = "http://${::ipaddress}:8000/${name}.cfg",
  $libvirt_pool       = 'default',
  $libvirt_network    = 'default',
  $install_ip         = undef,
  $install_netmask    = undef,
  $install_gateway    = undef,
) {
  require foreman_bootstrap::virt_install_setup

  file { "/var/www/html/${name}.cfg":
    ensure  => $ensure,
    content => template('foreman_bootstrap/kickstart.erb'),
  }

  file { "/usr/local/sbin/bootstrap-${name}.sh":
    ensure  => $ensure,
    content => template('foreman_bootstrap/bootstrap-virt.sh.erb'),
    mode    => '0755',
  }

}
