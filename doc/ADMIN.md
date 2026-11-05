# Admin notes

## Where the vault lives

The vault is `/home/yunohost.app/obsidian/vault`. Users allowed on the app can mount
it over SFTP to edit notes with a local editor; everything Obsidian itself stores
(settings, plugins, workspaces) sits next to it in that data directory.

## One session for everybody

The app streams a single desktop session: every user allowed by the app permission
shares the same window and the same vault. The permission defaults to all users —
restrict it to a group if the notes are private.

## No in-app login

Obsidian has no account of its own and the stream is not password protected: the
YunoHost portal (SSO) is the only door. Never expose the internal port.

## Screen size

The stream adapts the desktop to your browser window, so text is rendered at your own
window size instead of being scaled. The size chosen at install (`1920x1080` by
default) is only the starting size: change it in the app's config panel, or from the
CLI:

```bash
yunohost app config set obsidian main.display.resolution -v 1600x900
```

The size is written into the session launcher, so changing it restarts the app and
closes the current browser session.

## Adding files from the browser

Drag files onto the page: they are uploaded into `vault/attachments/` and Obsidian
picks them up immediately. To embed one in a note, drag it from Obsidian's file
explorer into the note, or set Obsidian's "Attachment folder path" to `attachments`
so its own pastes land there too. The streaming client's file panel lists the same
folder and offers downloads.

## Clipboard

The clipboard syncs both ways with the browser: copying inside Obsidian puts the text
on your own clipboard, and copying on your machine is available to paste in the
session. The sidebar's clipboard panel has the switches for each direction, plus
"Seamless" for automatic sync; the browser may ask once for clipboard permission.
This needs the HTTPS portal address — a plain-http port cannot reach your clipboard.

## Closing the window is not permanent

The desktop session — display, window manager, streaming server — keeps running when the
Obsidian window is closed, and the app is started again in place, so the browser stays
connected. To really end the session — before maintenance, for instance — stop the app:

```bash
yunohost app stop obsidian
```

## Minimized windows

A panel along the bottom of the screen lists the open windows: click the Obsidian entry
there to bring a minimized window back. Alt+Tab cannot help here — the browser keeps
that key combination for your own desktop.

## Logs and service

`journalctl -u obsidian -f` for the session, or `/var/log/obsidian/obsidian.log`.
Restarting the service re-creates the display and the stream. Encoder, bandwidth and
clipboard problems show up as `pixelflux` and `selkies` lines in that log.

## Upgrades and backups

`yunohost app upgrade obsidian` replaces the app files and keeps the vault and
desktop profile. Backups include the vault and that profile. The streaming server
(Selkies) is a pinned system package: the app installs it, follows the version in
`scripts/_common.sh`, and removes it on uninstall.

Obsidian Sync, the plugin store and community themes need outbound internet access
from the server.
