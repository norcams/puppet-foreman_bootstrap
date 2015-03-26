#
class foreman_bootstrap(
  $mirror   = $::foreman_bootstrap::params::mirror,
  $timezone = $::foreman_bootstrap::params::timezone,
  $keyboard = $::foreman_bootstrap::params::keyboard,
  $rootpw   = $::foreman_bootstrap::params::rootpw,
) inherits foreman_bootstrap::params {

  File {
    owner => 'root',
    group => 'root',
    mode => '0644',
  }

  file { ['/var/www',
          '/var/www/html',
          '/var/lib/tftpboot',
          '/var/lib/tftpboot/boot',
          '/var/lib/tftpboot/pxelinux.cfg']:
    ensure => directory,
  }

}
