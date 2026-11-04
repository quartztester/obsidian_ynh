# Obsidian for YunoHost

[![Install Obsidian with YunoHost](https://install-app.yunohost.org/install-with-yunohost.svg)](https://install-app.yunohost.org/?app=obsidian)

*[Lire ce readme en français.](./README_fr.md)*

> Obsidian is a Markdown note-taking app: notes stay plain files in a vault you own,
> linked with `[[wiki links]]` and extended by community plugins and themes.

This package runs the Obsidian desktop app on the server and streams the session
to the browser through noVNC, so the vault is reachable from any device.

## Features

- Notes as plain Markdown files, kept in `/home/yunohost.app/obsidian/`
- Wiki links, graph view, community plugins and themes
- Browser access behind the YunoHost portal, with a VNC password as a second lock
- Optional GPU acceleration for Intel, AMD and NVIDIA servers

## Screenshots

![Obsidian running in the browser](./doc/screenshots/desktop.png)

## Installation

```bash
yunohost app install obsidian
```

The install form asks for the domain and, optionally, which GPU vendor to expose.
Pick `none` to render in software.

## Documentation

- [Admin notes](./doc/ADMIN.md)
- Upstream: <https://obsidian.md/>

## License

The packaging is GPL-3.0. Obsidian itself is proprietary software distributed by
Dynalist Inc.; this package only downloads the official upstream release.
