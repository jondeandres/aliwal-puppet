# temporary puppetmaster fqdn
node 'vps68927.ovh.net' inherits default {
  $user  = 'root'
  $group = 'root'
  $home  = "/${user}"
  $ruby_version = '1.9.3-p194'

  package { 'facter':                 ensure => '1.7.5-1puppetlabs1'}
  package { 'puppetmaster-passenger': ensure => '3.4.3-1puppetlabs1'}
  package { 'puppet':                 ensure => '3.4.3-1puppetlabs1'}

  service { 'apache2': ensure => running }

  # RBENV #
  rbenv::install { $user:
    group => $group,
    home  => $home,
  }

  rbenv::compile { $ruby_version:
    user => $user,
    home => $home,
  }

  $gems = {
    'librarian' => { ensure => '0.1.2' },
    'r10k'      => { ensure => '1.3.2' },
  }

  $gems_defaults = {
    user => $user,
    home => $home,
    ruby => $ruby_version
  }

  create_resources('rbenv::gem', $gems, $gems_defaults)

}
