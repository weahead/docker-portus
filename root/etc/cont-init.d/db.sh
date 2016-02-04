#!/bin/execlineb -P

with-contenv

loopwhilex -x 0,255

foreground { echo "Waiting 10 seconds..." }

foreground { sleep 10 }

foreground { echo "Setting up database..." }

foreground { /usr/local/bundle/bin/rake db:create }

if { /usr/local/bundle/bin/rake db:migrate }

if { /usr/local/bundle/bin/rake db:seed }

foreground { echo "Done" }
