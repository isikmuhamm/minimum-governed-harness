#!/usr/bin/env sh
set -eu
SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
REPO_ROOT=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)
if command -v python3 >/dev/null 2>&1; then PYTHON=python3; elif command -v python >/dev/null 2>&1; then PYTHON=python; else echo "ERROR: Python 3 is required." >&2; exit 127; fi
exec "$PYTHON" "$REPO_ROOT/scripts/check.py" --root "$REPO_ROOT" "$@"
