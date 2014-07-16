#!/usr/bin/env ruby

# Modules installed from the Puppet Labs Forge by default  
forge "https://forge.puppetlabs.com"

# use dependencies defined in Modulefile
#modulefile

# Modules from git
# referencing commits since there aren't tags 
mod 'monit',
  :git => "git://github.com/puppetmodules/puppet-module-monit.git",
  :ref => "2220edd37ad15c54b82c77e054df073281d8ea33"

mod 'rbenv',
  :git => "git://github.com/alup/puppet-rbenv.git",
  :ref => "f06c3aee6831237201b0f1975978a1c7ddad9497"
