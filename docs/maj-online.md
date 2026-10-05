# `maj-online`

[← Back to README](../README.md#table-of-contents)

`maj-online` is a quick internet-connectivity check for scripts to call before doing anything network-dependent.

## What It Does

- pings `8.8.8.8` to check for a working internet connection
- exits with a distinct code depending on the result, so calling scripts can branch on it

## Supported Platforms

- macOS
- Linux

## Dependencies

- `ping` (the standard system one — no extra install needed)

## Install / First Run Summary

No install step. Just run it and check the exit code:

```bash
maj-online; echo "exit code: $?"
```

## Common Usage Examples

Use it as a guard before a network-dependent step:

```bash
maj-online && echo "online, continuing" || echo "not online, skipping"
```

Check the exit code directly:

```bash
maj-online
echo $?
```

## Important Behavior / Defaults

- Exit `0`: online (ping succeeded).
- Exit `1`: local network is unreachable (no route to the internet at all).
- Exit `2`: network reachable but the ping target didn't respond (100% packet loss) — treated as offline.
- No output is printed either way; only the exit code carries the result.

## Notes / Caveats

- Relies on `8.8.8.8` (Google DNS) responding to ICMP — if that specific address is blocked on your network but the internet is otherwise fine, this will report offline.

[↑ Back to README TOC](../README.md#table-of-contents)
