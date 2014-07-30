define initscript::app($user, $home, $app_type, $app_name, $app_daemon, $env='development') {
  case $app_type {
    'ruby': {}
    'python': {}
    default: { fail("App type ${app_type} is not supported.") }
  }

  file { "/etc/init.d/${env}_${app_name}_${app_daemon}":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0755',
    content => template("unicorn/${app_type}_init.erb"),
  }
}
