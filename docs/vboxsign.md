# `vboxsign`

[← Back to README](../README.md#table-of-contents)

`vboxsign` signs and loads the VirtualBox kernel modules on a Linux host with Secure Boot enabled.

## What It Does

- signs the `vboxdrv`, `vboxnetflt`, `vboxnetadp`, and `vboxpci` kernel modules with a MOK (Machine Owner Key) keypair, skipping any module that's already signed
- loads each module with `modprobe` after signing
- re-execs itself with `sudo` automatically if not already run as root

## Supported Platforms

- Linux (with Secure Boot and a MOK keypair enrolled via `mokutil`)

## Dependencies

- a MOK keypair (`MOK.priv`, `MOK.der`) already generated and enrolled with `mokutil --import`
- matching `linux-headers-$(uname -r)` installed (for the kernel's `sign-file` tool)
- VirtualBox installed (for the kernel modules themselves)

## Install / First Run Summary

Point the script at your key directory one of three ways (CLI flag beats env var beats the in-script default):

- **Edit the script** — change the `dir=` default placeholder (`/home/directory/of/keys`) to wherever your `MOK.priv`/`MOK.der` actually live.
- **Set `VBOXSIGN_KEYS_DIR`** in your environment.
- **Pass `-k`/`--keys-dir DIR`** for a one-run override.

Then:

```bash
sudo vboxsign
```

(or just `vboxsign` — it re-execs itself under `sudo -E` if needed, preserving `VBOXSIGN_KEYS_DIR`)

## Common Usage Examples

Run after a kernel update, when Secure Boot is rejecting the unsigned VirtualBox modules:

```bash
vboxsign
```

Point at a non-default key directory for this run only, without editing the script:

```bash
vboxsign --keys-dir /mnt/keys/vbox-mok
```

## Important Behavior / Defaults

- Requires root; automatically re-runs itself via `sudo` if not already root.
- Skips signing (but still attempts to load) any module that's already signed.
- The commented-out block for an encrypted (GPG-protected) private key is inert by default — the script expects an unencrypted `MOK.priv` unless you uncomment and adapt that section yourself.
- The final `shred -vfuz MOK.priv` cleanup line is also commented out by default, so the private key is left in place after a run unless you opt in.

## Notes / Caveats

- The hardcoded key directory (`/home/directory/of/keys`) is a placeholder by design (this repo is public) — point it at your own key location by editing the script, setting `VBOXSIGN_KEYS_DIR`, or passing `--keys-dir`.
- Designed to be re-run safely after every kernel update, since new kernel builds need the modules re-signed against the running kernel's headers.

[↑ Back to README TOC](../README.md#table-of-contents)
