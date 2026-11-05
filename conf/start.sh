#!/bin/bash
set -e

# Display number = port: unique per install, no registry to keep.
export DISPLAY=":__PORT__"
export HOME="__DATA_DIR__"
export XDG_CONFIG_HOME="__DATA_DIR__/.config"
export XDG_RUNTIME_DIR="__DATA_DIR__/run"
mkdir -p "$XDG_RUNTIME_DIR"
chmod 700 "$XDG_RUNTIME_DIR"

Xvfb "$DISPLAY" -screen 0 "__RESOLUTION__x24" -nolisten tcp &
for _ in $(seq 50); do
    xdpyinfo >/dev/null 2>&1 && break
    sleep 0.2
done

# A WM is what lets the user move and resize the window; the panel restores a minimized one.
openbox --sm-disable &
tint2 &

# Loopback only: nginx is the single door, the portal decides who gets in. Selkies captures the
# display itself and carries clipboard and drag-and-drop uploads, so no VNC bridge sits in front.
selkies --port=__PORT__ --enable-https=false --enable-basic-auth=false --audio-enabled=false \
    --encoder=h264enc --file-manager-path="__DATA_DIR__/vault/attachments" &

# Closing the window must not drop the browser: display and stream stay up, and the app comes
# back in place. Only a lost display, or an app that cannot start, ends the unit.
fast_exits=0
while :; do
    started=$(date +%s)
    "__INSTALL_DIR__/obsidian" --no-sandbox --disable-gpu --disable-dev-shm-usage || true
    if (( $(date +%s) - started < 5 )); then
        fast_exits=$((fast_exits + 1))
        (( fast_exits < 5 )) || exit 1
    else
        fast_exits=0
    fi
    sleep 1
    xdpyinfo >/dev/null 2>&1 || exit 1
done
