#!/bin/sh
set -eu

# `docker exec ... sau` starts as root by default. Match Hermes' own wrapper so
# cookies, QR images, logs, and browser profile files stay owned by the runtime
# hermes UID instead of root.
if [ "$(id -u)" = 0 ] && [ "${SAU_ALREADY_DROPPED:-0}" != 1 ]; then
    exec /command/s6-setuidgid hermes env SAU_ALREADY_DROPPED=1 "$0" "$@"
fi

export HOME="${HERMES_HOME:-/opt/data}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache/sau}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share/sau}"

# Keep Patchright's browser build separate from the Playwright browser used by
# Hermes itself. The real CLI and Python live in the isolated SAU venv.
export PLAYWRIGHT_BROWSERS_PATH=/opt/social-auto-upload/.patchright
mkdir -p "$XDG_CONFIG_HOME" "$XDG_CACHE_HOME" "$XDG_DATA_HOME"
cd /opt/social-auto-upload
exec /opt/social-auto-upload/.venv/bin/sau "$@"
