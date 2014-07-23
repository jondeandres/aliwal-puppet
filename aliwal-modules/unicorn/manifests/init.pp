define unicorn($user_name, $home_dir, $project_name, $projects_dir, $env='development') {
  file { "/etc/init.d/unicorn_${env}_${project_name}":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0755',
    content => template('unicorn/unicorn.erb'),
    notify  => Service["unicorn_${project_name}_${environment}"],
  }
}
