define initscript::daemon($user, $home, $app, $type, $daemon, $env='development') {
  case $type {
    'ruby', 'python': {}
    default: { fail("App type ${type} is not supported.") }
  }

  file { "/etc/init.d/${app}-${env}":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0755',
    content => template("initscript/init.erb"),
  }
}
