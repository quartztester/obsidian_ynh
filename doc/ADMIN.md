# Admin notes

## Where the vault lives

Vaults are stored in `/home/yunohost.app/obsidian/`. Create or open one from the
app's "Open folder as vault" button; nothing is stored outside that directory.

## One session for everybody

The package streams a single desktop session, so every user allowed by the app's
permission shares the same vault windows. Keep the permission on `admins` unless
that is what you want.

## Two passwords

The YunoHost portal gates the page. The browser client then asks for the VNC
password, readable with:

```bash
yunohost app setting obsidian vnc_password
```

Change it from the app's config panel.

## GPU acceleration

The option passes the GPU to the session, adds the service user to the `video`
and `render` groups, installs the VA-API userspace drivers and enables Electron's
hardware video decode.

Be aware of the limit: the bundled virtual X server (TigerVNC's `Xvnc`) has no
DRI3, so the desktop itself keeps rendering in software. Forcing hardware GL there
makes Chromium exit with "GPU process isn't usable" and the session restart in a
loop, which is why the package only switches on decode features. Hardware
rendering would need an X server natively bound to the GPU.

Intel users on bookworm can improve decode support with the non-free
`intel-media-va-driver` package, which the package does not install for you.

## Services and logs

- `obsidian` — the virtual display plus the app.
- `obsidian-novnc` — the browser bridge.

Both log to `/var/log/obsidian/obsidian.log`.

## Upgrading

`yunohost app upgrade obsidian` fetches the pinned upstream release. Vaults and
settings survive; the extracted app files are replaced.
