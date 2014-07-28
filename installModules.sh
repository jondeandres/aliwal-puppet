#!/bin/bash

# Temporary script to install modules managed by librarian
librarian-puppet install
librarian-puppet update aliwal/unicorn
librarian-puppet update aliwal/keys
rsync -a modules/puppet-module-monit/ modules/monit/
