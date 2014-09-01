#!/usr/bin/env ruby

## Modules from the Puppet Labs Forge by default
forge "https://forgeapi.puppetlabs.com"

# use dependencies defined in Modulefile
#modulefile

mod 'thomasvandoren/redis', "0.10.0"
mod 'alup/rbenv',
  :git => "git://github.com/alup/puppet-rbenv"
mod 'puppetlabs/stdlib', "4.3.2"
mod 'puppetlabs/apt', "1.5.1"
mod 'puppetlabs/mysql', "2.3.1"

## Modules from git
# not working if module's name contains a dash :(
# use 'installModules.sh' script
mod 'puppetmodules/puppet-module-monit',
  :git => "git@github.com:theforeman/puppet-module-monit.git"
mod 'stankevich/stankevich-python',
  :git => "git://github.com/stankevich/puppet-python.git"

# ALIWAL modules
mod 'aliwal/initscript',
  :git => "git@github.com:jondeandres/aliwal-puppet.git",
  :path => "aliwal-modules/initscript"

mod 'aliwal/keys',
  :git => "git@github.com:jondeandres/aliwal-puppet.git",
  :path => "aliwal-modules/keys"

mod 'aliwal/puma',
  :git => "git@github.com:jondeandres/aliwal-puppet.git",
  :path => "aliwal-modules/puma"

mod 'aliwal/git_utils',
  :git => "git@github.com:jondeandres/aliwal-puppet.git",
  :path => "aliwal-modules/git_utils"

mod 'aliwal/environments',
  :git => "git@github.com:jondeandres/aliwal-puppet.git",
  :path => "aliwal-modules/environments"
