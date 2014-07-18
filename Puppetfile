#!/usr/bin/env ruby

# Modules installed from the Puppet Labs Forge by default
forge "https://forgeapi.puppetlabs.com"

# use dependencies defined in Modulefile
#modulefile

mod 'thomasvandoren/redis', "0.10.0"
mod 'alup/rbenv', "1.2.0"
mod 'puppetlabs/stdlib', "4.3.2"
mod 'puppetlabs/apt', "1.5.1"

# Modules from git
# not working if module's name contains a dash :(
# use 'installModules.sh' script
mod 'puppetmodules/puppet-module-monit',
  :git => "git://github.com/puppetmodules/puppet-module-monit.git",
  # referencing commits since there aren't tags
  :ref => "2220edd37ad15c54b82c77e054df073281d8ea33"
