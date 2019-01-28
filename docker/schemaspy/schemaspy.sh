#!/usr/bin/env bash

set -Ceuo pipefail

cd $(cd $(dirname $0) && pwd)
DIR=$(pwd)

docker run --rm -v "${DIR}/doc:/output" --net="host" schemaspy/schemaspy:snapshot -t pgsql \
  -host 127.0.0.1:5432 \
  -db chat \
  -s chat \
  -u chat \
  -p mysecretpassword

exit 0
