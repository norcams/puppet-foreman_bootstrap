#
# Creates bootstrap instances from hiera data
#
class foreman_bootstrap::instances {
  $virt_install = hiera_hash('foreman_bootstrap::virt_install', undef)
  $tftp_install = hiera_hash('foreman_bootstrap::tftp_install', undef)

  if $virt_install {
    create_resources('::foreman_bootstrap::virt_install', $virt_install)
  }

  if $tftp_install {
    create_resources('::foreman_bootstrap::tftp_install', $tftp_install)
  }
}
