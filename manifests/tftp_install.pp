#
define foreman_bootstrap::tftp_install (
  $ensure          = 'present',
  $certname        = $name
  $hostname        = $name
  $dhcp_startindex = 100
  $dhcp_endindex   = 100
  $dhcp_if         = 'eth0'
  $macaddress      = 'default',
  $ks_url          = "http://${::ipaddress}:8000/${name}.cfg"
) {

  $pxelinux_i = regsubst($macaddress,':','-','G')
  $pxelinux_file = downcase($pxelinux_i)
  file { "/var/lib/tftpboot/pxelinux.cfg/${pxelinux_file}":
    ensure  => $ensure,
    content => template('pxelinux.erb'),
  }

  file { "/var/www/html/${name}.cfg":
    ensure  => $ensure,
    content => template('kickstart.erb'),
  }

  $if_ip = inline_template("<%= scope.lookupvar('::ipaddress_${dhcp_if}') -%>")

  $start_cidr  = ip_network($if_ip, $dhcp_startindex)
  $end_cidr    = ip_network($if_ip, $dhcp_endindex)
  $range_start = ip_address($start_cidr)
  $range_end   = ip_address($end_cidr)

  file { "/usr/local/sbin/bootstrap-tftp-${name}.sh":
    ensure  => $ensure
    content => template('tftp-node.sh.erb'),
  }

}
