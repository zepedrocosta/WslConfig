#!/usr/bin/env bash

CONF_DIR="/home/josec/.local/state/syncthing"
OUT_DIR="/home/josec/syncthing-backups"
MAX_BACKUPS=10
LAST_RUN_FILE="${OUT_DIR}/.last_run"

TODAY=$(date +"%Y-%m-%d")

mkdir -p "$OUT_DIR"

# Only run once per day
if [ -f "$LAST_RUN_FILE" ] && [ "$(cat "$LAST_RUN_FILE")" = "$TODAY" ]; then
    exit 0
fi

TIMESTAMP=$(date +"%Y%m%d-%H%M%S")
OUT_FILE="${OUT_DIR}/syncthing-backup-${TIMESTAMP}.tar.gz"

set -e

if [ -d "$CONF_DIR" ]; then
	tar -czf "$OUT_FILE" -C "$(dirname "$CONF_DIR")" "$(basename "$CONF_DIR")"
fi

# cleanup: list backups, sort newest first, skip top N, delete the rest
cd "$OUT_DIR"
ls -1t syncthing-backup-*.tar.gz | awk "NR>$MAX_BACKUPS" | xargs -r rm -f
