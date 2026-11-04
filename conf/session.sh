#!/bin/bash

set -e
source "$(dirname "$0")/env"

# one X display per instance: first free socket wins
for n in $(seq 20 99); do
    [ -e "/tmp/.X11-unix/X$n" ] || break
done
export DISPLAY=":$n"

Xvnc "$DISPLAY" -geometry "$GEOMETRY" -depth 24 -rfbport "$PORT_VNC" -localhost \
    -SecurityTypes VncAuth -PasswordFile "$DATA_DIR/.vncpasswd" -AlwaysShared &

for _ in $(seq 1 40); do
    [ -e "/tmp/.X11-unix/X$n" ] && break
    sleep 0.5
done

# shellcheck disable=SC2086
exec "$INSTALL_DIR/obsidian" --no-sandbox --disable-dev-shm-usage $ELECTRON_FLAGS
