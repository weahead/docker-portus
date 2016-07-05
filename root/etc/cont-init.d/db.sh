#!/bin/execlineb -P

with-contenv

foreground {
  loopwhilex -x 0

  foreground { echo "Checking if database is up..." }

  ifelse
  {
    importas -u PORTUS_PRODUCTION_HOST PORTUS_PRODUCTION_HOST
    importas -u PORTUS_PRODUCTION_USERNAME PORTUS_PRODUCTION_USERNAME
    importas -u PORTUS_PRODUCTION_PASSWORD PORTUS_PRODUCTION_PASSWORD
    importas -u PORTUS_PRODUCTION_DATABASE PORTUS_PRODUCTION_DATABASE
    mysql -h${PORTUS_PRODUCTION_HOST}
          -u${PORTUS_PRODUCTION_USERNAME}
          -p${PORTUS_PRODUCTION_PASSWORD}
          -e";"
  }
  {
    echo "Database is up!"
  }

  foreground { echo "Database is not up, retrying in 1 second" }
  foreground { sleep 1 }
  exit 1
}

ifelse -n {
  # redirfd -w 1 /dev/null fdmove -c 2 1

  foreground { echo "Checking if tables exist..." }

  backtick -i TABLES {
    importas -u PORTUS_PRODUCTION_HOST PORTUS_PRODUCTION_HOST
    importas -u PORTUS_PRODUCTION_USERNAME PORTUS_PRODUCTION_USERNAME
    importas -u PORTUS_PRODUCTION_PASSWORD PORTUS_PRODUCTION_PASSWORD
    importas -u PORTUS_PRODUCTION_DATABASE PORTUS_PRODUCTION_DATABASE
    mysql -h${PORTUS_PRODUCTION_HOST}
          -u${PORTUS_PRODUCTION_USERNAME}
          -p${PORTUS_PRODUCTION_PASSWORD}
          -e"USE ${PORTUS_PRODUCTION_DATABASE}; SHOW TABLES;"
  }

  if {
    importas -u TABLES TABLES
    pipeline {
      echo ${TABLES}
    }
    grep -q "schema_migrations"
  }

  foreground { echo "Tables exist, running migrations only..." }
  bundle exec rake db:migrate
}
{
  foreground { echo "Setting up database..." }
  bundle exec rake db:create db:schema:load db:seed
}

echo "Done!"
