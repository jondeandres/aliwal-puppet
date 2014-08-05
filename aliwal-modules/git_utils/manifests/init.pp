class git_utils (
  $user,
  $home,
  ) {

  # Don't check github host key
  exec { 'HostKeyGithub':
    command => "su - ${user} -c 'echo -e \"Host github.com\n\tStrictHostKeyChecking no\n\" >> ${home}/.ssh/config'",
    cwd     => $home,
    creates => "${home}/.ssh/config",
    path    => ['/usr/bin', '/usr/sbin', '/bin'],
    require => User[$user]
  }
}
