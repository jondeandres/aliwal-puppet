#!/bin/bash

# Temporary script to install modules managed by librarian
librarian-puppet install
rsync -a modules/puppet-module-monit/ modules/monit/
