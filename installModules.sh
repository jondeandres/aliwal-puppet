#!/bin/bash

# Temporary script to install modules managed by librarian
librarian-puppet install
librarian-puppet update aliwal/initscript
librarian-puppet update aliwal/keys
librarian-puppet update aliwal/puma
librarian-puppet update aliwal/git_utils
rsync -a modules/puppet-module-monit/ modules/monit/
