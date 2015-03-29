#
class foreman_bootstrap::tftp_setup {

  require foreman_bootstrap

  file { [
          '/var/lib/tftpboot',
          '/var/lib/tftpboot/boot',
          '/var/lib/tftpboot/pxelinux.cfg']:
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  ensure_resource('package', 'syslinux', {'ensure' => 'installed'})

}
