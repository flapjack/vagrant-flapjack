#!/bin/bash

appdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

curl -w 'response: %{http_code} \n' -X POST -H "Content-type: application/json" \
  -d @${appdir}/examples/entities_foo-app-01_and_foo-db-01.json \
  http://localhost:3081/entities

