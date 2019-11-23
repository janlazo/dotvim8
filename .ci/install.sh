#!/bin/bash
set -eu
cd "$(dirname "$0")/.."

export NVM_DIR="$HOME/.nvm"
rm -rf "$NVM_DIR"
mkdir -p "$NVM_DIR"
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash
source "$NVM_DIR/nvm.sh" --no-use
nvm install lts/carbon
nvm use lts/carbon

echo node $(node --version)
echo npm $(npm --version)
ruby --version
echo gem $(gem --version)

./bin/install_deps.sh
