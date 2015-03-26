#
define foreman_bootstrap::virt_install(
  $ensure          = 'present',
  $certname        = $name,
  $hostname        = $name,
  $ks_url          = "http://${::ipaddress}:8000/${name}.cfg",
  $install_ip      = undef,
  $install_netmask = undef,
  $install_gateway = undef,
) {

  file { "/var/www/html/${certname}.cfg":
    ensure  => $ensure,
    content => template('kickstart.erb'),
  }

  file { "/usr/local/sbin/bootstrap-virt-install-${name}.sh":
    ensure  => $ensure,
    content => template('virt-install-node.sh.erb'),
  }

}
