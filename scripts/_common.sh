#!/bin/bash

#=================================================
# COMMON VARIABLES AND CUSTOM HELPERS
#=================================================

# No --use-gl=egl / --ignore-gpu-blocklist: forcing GL on the virtual X server makes
# Chromium die with "GPU process isn't usable", which crash-loops the whole session
_obsidian_gpu_flags() {
    case "$gpu" in
        intel | amd) echo "--enable-features=VaapiVideoDecodeLinuxGL,VaapiVideoDecoder" ;;
        nvidia) echo "--enable-features=VaapiVideoDecodeLinuxGL" ;;
        *) echo "" ;;
    esac
}

_obsidian_check_gpu() {
    case "$gpu" in
        intel | amd)
            ls /dev/dri/renderD* > /dev/null 2>&1 || ynh_die "No /dev/dri render node: ${gpu} acceleration needs a GPU driver on the host."
            usermod -aG video,render "$app"
            ;;
        nvidia)
            [ -e /dev/nvidia0 ] || ynh_die "No /dev/nvidia0: nvidia acceleration needs the proprietary NVIDIA driver on the host."
            usermod -aG video "$app"
            ;;
    esac
}

_obsidian_deploy_session() {
    local electron_flags
    electron_flags="$(_obsidian_gpu_flags)"

    mkdir -p "/var/log/$app"
    chown "$app:$app" "/var/log/$app"

    ynh_config_add --template="env" --destination="$install_dir/env"
    ynh_config_add --template="session.sh" --destination="$install_dir/session.sh"
    chmod 750 "$install_dir/session.sh"
    chown "$app:$app" "$install_dir/env"

    # Xvnc only reads vncpasswd's obfuscated form, never the plain password
    echo "$vnc_password" | vncpasswd -f > "$data_dir/.vncpasswd"
    chmod 600 "$data_dir/.vncpasswd"
    chown "$app:$app" "$data_dir/.vncpasswd"
}

_obsidian_wait_web() {
    for _ in $(seq 1 30); do
        curl -fsS "http://127.0.0.1:$port/vnc.html" > /dev/null 2>&1 && return 0
        sleep 1
    done
    ynh_die "noVNC did not answer on port $port"
}
