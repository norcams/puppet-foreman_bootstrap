#
class foreman_bootstrap(
  $mirror     = $::foreman_bootstrap::params::mirror,
  $timezone   = $::foreman_bootstrap::params::timezone,
  $keyboard   = $::foreman_bootstrap::params::keyboard,
  $rootpw     = $::foreman_bootstrap::params::rootpw,
  $nameserver = $::foreman_bootstrap::params::nameserver,
) inherits foreman_bootstrap::params {

  File {
    owner => 'root',
    group => 'root',
    mode => '0644',
  }

  file { ['/var/www', '/var/www/html']:
    ensure => directory,
  }

}
