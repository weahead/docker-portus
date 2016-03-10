#!/bin/bash

PORTUS_VERSION=2.0.3

cd Portus

CHECKOUT_VERSION=$(git describe --tags)

cd ..

if [ "${CHECKOUT_VERSION}" != "${PORTUS_VERSION}" ]; then
  echo "Version of checked out submodule 'Portus' does not match build version."
  echo "Portus: ${CHECKOUT_VERSION}"
  echo "Build: ${PORTUS_VERSION}"
  echo "They need to match!"
  echo "Aborting."
  exit 1
fi

docker build -t weahead/portus:${PORTUS_VERSION} .
