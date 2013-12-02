#!/bin/bash

appdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

curl -w 'response: %{http_code} \n' -X POST -H "Content-type: application/json" \
  -d @${appdir}/examples/contacts_ada_and_charles.json \
  http://localhost:3081/contacts

