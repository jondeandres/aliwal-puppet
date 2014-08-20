define environments::resources::profile {
  file { "/etc/profile.d/${name}.sh":
		mode => '0644',
		owner => 'root',
		group => 'nogroup',
		source => "puppet:///modules/environments/profile_${name}.sh",
    ensure => 'file'
  }
}
