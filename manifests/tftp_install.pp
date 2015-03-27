#
define foreman_bootstrap::tftp_install (
  $ensure           = 'present',
  $certname         = $name,
  $hostname         = $name,
  $macaddress       = 'default',
  $ks_url           = "http://${dhcp_ip}:8000/${name}.cfg",
  $dhcp_interface   = 'eth1',
  $dhcp_range_start = '10.0.0.10',
  $dhcp_range_end   = '10.0.0.10',
  $dhcp_gateway     = '10.0.0.1',
) {
  require foreman_bootstrap::tftp_setup

  $pxelinux_i = regsubst($macaddress,':','-','G')
  $pxelinux_file = downcase($pxelinux_i)
  file { "/var/lib/tftpboot/pxelinux.cfg/${pxelinux_file}":
    ensure  => $ensure,
    content => template('foreman_bootstrap/pxelinux.erb'),
  }

  file { "/var/www/html/${name}.cfg":
    ensure  => $ensure,
    content => template('foreman_bootstrap/kickstart.erb'),
  }

  file { "/usr/local/sbin/bootstrap-${certname}.sh":
    ensure  => $ensure,
    content => template('foreman_bootstrap/bootstrap-tftp.sh.erb'),
    mode    => '0755',
  }

}
