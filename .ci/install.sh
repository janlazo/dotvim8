#!/bin/bash
set -eu
cd "$(dirname "$0")/.."

NVM_DIR="$HOME/.nvm"
test -f "$NVM_DIR/nvm.sh" && source "$NVM_DIR/nvm.sh" --no-use
if command -v nvm >/dev/null 2>&1; then
  nvm install lts/carbon
  nvm use lts/carbon
fi

./bin/install_deps.sh
