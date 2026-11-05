#!/bin/bash

#=================================================
# COMMON VARIABLES AND CUSTOM HELPERS
#=================================================

# Debian does not carry the streaming server: pin the upstream .deb, per architecture.
selkies_version="2.2.0-1~debianbookworm"
case "$(dpkg --print-architecture)" in
    amd64) selkies_sha256="e052932442c7d99401c8cac9ad899451c7cf7b172de83ecf2d0bc82f8156aaef" ;;
    arm64) selkies_sha256="f9f3a531eade2305f4d2d36a5ecb0b3e5a1d1b6f05d0dea5e61b6ce209e2ea65" ;;
esac

ynh_obsidian_deploy() {
    # Settings added after the first release are missing when upgrading or restoring,
    # and the core leaves their variable empty during an upgrade: read it from the
    # settings and export it so the launcher template renders.
    resolution=$(ynh_app_setting_get --key=resolution || true)
    if ! [[ "$resolution" =~ ^[0-9]{3,4}x[0-9]{3,4}$ ]]; then
        resolution=1920x1080
        ynh_app_setting_set --key=resolution --value="$resolution"
    fi
    export resolution

    ynh_setup_source --dest_dir="$install_dir" "$@"
    # systemd's append: log target needs the directory to exist.
    mkdir -p "/var/log/$app"
    chown "$app:$app" "/var/log/$app"
    ynh_config_add --template="start.sh" --destination="$install_dir/start.sh"
    chmod 755 "$install_dir/start.sh" "$install_dir/obsidian"
    chown -R "$app:$app" "$install_dir"
}

# The .deb carries its own Python, screen capture and web client, so a version check is enough.
ynh_obsidian_install_selkies() {
    local installed deb
    installed=$(dpkg-query -W -f='${Version}' selkies 2>/dev/null || true)
    if [ "$installed" = "$selkies_version" ]; then
        return
    fi

    deb="/var/cache/$app/selkies.deb"
    mkdir -p "$(dirname "$deb")"
    curl -fsSL -o "$deb" \
        "https://github.com/selkies-project/selkies/releases/download/2.2.0/selkies-2.2.0-debianbookworm-$(dpkg --print-architecture).deb"
    if ! echo "$selkies_sha256  $deb" | sha256sum --check --status; then
        rm -f "$deb"
        echo "The Selkies download does not match the pinned checksum" >&2
        exit 1
    fi
    DEBIAN_FRONTEND=noninteractive apt-get install --yes "$deb"
    rm -f "$deb"
}

ynh_obsidian_prepare_vault() {
    install -d -o "$app" -g "$app" -m 755 "$data_dir/vault"
    # Drag-and-drop uploads land here, written by the app user: nginx no longer touches the vault.
    install -d -o "$app" -g "$app" -m 755 "$data_dir/vault/attachments"
}

# Before Selkies the browser wrote dropped files through nginx, which needed www-data in the app group.
ynh_obsidian_remove_uploads() {
    if id -nG www-data | tr ' ' '\n' | grep -qxF "$app"; then
        gpasswd -d www-data "$app"
    fi
}
