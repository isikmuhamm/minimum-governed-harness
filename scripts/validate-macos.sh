#!/usr/bin/env sh
# ContextRail uses the same POSIX contract on macOS and Linux.
SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
exec sh "$SCRIPT_DIR/validate-linux.sh" "$@"
