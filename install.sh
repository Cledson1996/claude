#!/usr/bin/env bash
# Instala o plugin jc da JusCash no Claude Code
# Uso: bash install.sh [--scope user|project|local]
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
node "$DIR/install.js" "$@"
