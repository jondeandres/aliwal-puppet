define git_utils::clone (
  $user,
  $home,
  $app,
  $bundle_install = false
  ) {

  exec { "git-clone-${app}":
    command => "su - ${user} -c 'git clone git@github.com:jondeandres/${app}.git'",
    cwd     => $home,
    creates => "${home}/${app}",
    path    => ['/usr/bin', '/usr/sbin', '/bin'],
    require => [
      Package['git-core'],
      File["${home}/.ssh/id_dsa"],
      Exec['HostKeyGithub']
    ]
  }

  if $bundle_install {
    exec { "${app} install":
      command => "su - ${user} -c 'cd ${home}/${app} && bundle install'",
      path    => ['/usr/bin', '/usr/sbin', '/bin'],
      require => Exec["git-clone-${app}"],
    }
  }
}
