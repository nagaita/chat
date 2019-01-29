#!/usr/bin/env bash
set -Ceuo pipefail

cd "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cd ../docker
docker-compose stop && echo y | docker-compose rm && docker-compose build && docker-compose up -d
