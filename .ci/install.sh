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

# Python
python --version
python -m pip --version
if command -v python3 >/dev/null 2>&1; then
  python3 --version
  python3 -m pip --version || true
fi

# Nodejs
echo node $(node --version)
echo npm $(npm --version)

# Ruby
ruby --version
echo gem $(gem --version)

# Perl
perl --version
cpanm --version

./bin/install_deps.sh
