#
define foreman_bootstrap::tftp_install (
  $ensure          = 'present',
  $certname        = $name,
  $hostname        = $name,
  $dhcp_startindex = 100,
  $dhcp_endindex   = 100,
  $dhcp_if         = 'eth0',
  $macaddress      = 'default',
  $ks_url          = "http://${::ipaddress}:8000/${name}.cfg",
) {

  include foreman_bootstrap
  include foreman_bootstrap::tftp_setup

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

  $if_ip   = inline_template("<%= scope.lookupvar('::ipaddress_${dhcp_if}') -%>")
  $if_cidr = inline_template("<%= IPAddr.new(scope.lookupvar('::netmask_${dhcp_if}')).to_i.to_s(2).count(\'1\') %>")

  $if_ip_cidr = "${if_ip}/${if_cidr}"
  notice "dhcp: $dhcp_if cidr => $if_ip_cidr"
  $start_cidr  = ip_network($if_ip_cidr, $dhcp_startindex)
  $end_cidr    = ip_network($if_ip_cidr, $dhcp_endindex)
  $range_start = ip_address($start_cidr)
  $range_end   = ip_address($end_cidr)
  notice "dhcp: range_start = $range_start range_end = $range_end"

  file { "/usr/local/sbin/bootstrap-${certname}.sh":
    ensure  => $ensure,
    content => template('foreman_bootstrap/tftp-node.sh.erb'),
    mode    => '0755',
  }

}
