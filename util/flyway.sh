#!/usr/bin/env bash
set -Ceuo pipefail

cd "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cd ..

./gradlew flywayMigrate -i
