#!/bin/execlineb -P

with-contenv

foreground { echo "Waiting for Portus config file..." }

foreground {

  loopwhilex -x 0

  foreground { sleep 5 }

  cp /usr/local/etc/portus/portus.conf /portus/config/config-local.yml

}

echo "Portus config file successfully copied!"
