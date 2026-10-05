# `minterpolate`

[← Back to README](../README.md#table-of-contents)

`minterpolate` runs FFmpeg's motion-interpolation filter across multiple CPU cores by slicing the source video, processing each slice in parallel, then concatenating the results.

## What It Does

- splits the input video into fixed-length slices
- runs FFmpeg's `minterpolate` filter on each slice in parallel (one process per available core, minus 2)
- re-encodes each slice with the chosen encoder, then concatenates them back into one output file
- optionally trims the source to a start/end range before slicing
- cleans up its own temporary slice files when done

## Supported Platforms

- macOS
- Linux

## Dependencies

- `ffmpeg` (also used to detect CPU core count via `nproc`/`sysctl`)
- `xargs`, `nice` (standard on macOS/Linux)

## Install / First Run Summary

No install step beyond having `ffmpeg` on `PATH` (or pointing `-b` at it explicitly). Basic run, converting to 60fps:

```bash
minterpolate -i input.mp4 output.mp4
```

## Common Usage Examples

Interpolate the whole file to 60fps with defaults:

```bash
minterpolate -i input.mp4 output.mp4
```

Target 120fps with a specific encoder and more parallel workers:

```bash
minterpolate -i input.mp4 -r 120 -e libx265 -p 8 output.mp4
```

Only process a portion of the source (from 1:00 to 3:30):

```bash
minterpolate -i input.mp4 -s 00:01:00 -t 00:03:30 output.mp4
```

Show all options and their defaults:

```bash
minterpolate
```

## Important Behavior / Defaults

- Default target frame rate is 60fps, default slice length is 10 seconds, default encoder is `libx264` at `-crf 20 -preset slow`.
- Process count defaults to (logical CPU count − 2); override with `-p`.
- `-s`/`-t` trim the source into a temporary `_cut.mp4` before slicing, rather than trimming in place.
- Working files (`_cut.mp4`, `_s_*.mp4`, `_m__s_*.mp4`, `_list.txt`) are written to the current directory and removed automatically at the start and end of a run.

## Notes / Caveats

- The script's own comment warns the concat points between slices "may be weird" — expect possible minor seams at slice boundaries.
- If a run is interrupted mid-way, temporary slice files can be left behind; re-running cleans them up before starting again, but a stray `_m__s_*.mp4`/`_s_*.mp4` from an interrupted run could in principle mix with a fresh run's slices if left in the same directory.
- Long or high-resolution sources with many slices can be resource-intensive — the parallelism trades disk and memory for wall-clock time.

[↑ Back to README TOC](../README.md#table-of-contents)
