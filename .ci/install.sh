#!/bin/sh
set -eu
cd "$(dirname "$0")/.."

go get github.com/haya14busa/go-vimlparser/cmd/vimlparser
