#!/bin/bash

# Temporary script to install modules managed by librarian
librarian-puppet install
librarian-puppet update aliwal/initscript
librarian-puppet update aliwal/keys
librarian-puppet update aliwal/puma
rsync -a modules/puppet-module-monit/ modules/monit/
