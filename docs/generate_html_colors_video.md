# `generate_html_colors_video`

[← Back to README](../README.md#table-of-contents)

`generate_html_colors_video` renders a 12-hour 4K solid-color video for every named HTML/CSS color.

## What It Does

- generates one 4K (3840x2160) video per HTML/CSS named color (148 colors)
- each video is 12 hours long, a solid fill of that color
- names each output file `<hex>_<ColorName>.mp4`
- tags each video with title/artist/album/comment/copyright/description metadata built from the color name, hex, and RGB values

## Supported Platforms

- macOS
- Linux

## Dependencies

- `ffmpeg`
- optionally sources `${HOME}/bin/maj-source` if present (harmless if missing)

## Install / First Run Summary

No install step beyond having `ffmpeg` on `PATH`. Run it from an empty directory you're happy to fill with video files:

```bash
mkdir colors && cd colors
generate_html_colors_video
```

## Common Usage Examples

Generate the full set with the defaults (12 hours per color, 4K, current directory):

```bash
generate_html_colors_video
```

Render a short, low-resolution test pass instead of committing to the full 12-hour/4K run:

```bash
generate_html_colors_video --resolution 640x360 --duration 00:00:10 --outdir ./test-colors
```

Options:

| Flag | Default | Overrides |
| --- | --- | --- |
| `-r`, `--resolution WxH` | `3840x2160` | Video resolution for this run. |
| `-d`, `--duration HH:MM:SS` | `12:00:00` | Length of each color's video for this run. |
| `-o`, `--outdir DIR` | `.` (current directory) | Directory the videos are written into (created if missing). |

Every color in the built-in 148-color list is still generated every run — there's no flag to render a subset.

## Important Behavior / Defaults

- Runs sequentially, one color at a time, and does not skip or resume — expect a very long total runtime at the defaults (148 colors × up to 12 hours each if left to finish).
- Resolution, duration, and output directory are overridable per run via the flags above; the color set itself is not.
- Existing output files with the same name are overwritten (`-y`).

## Notes / Caveats

- Each finished file is a full-length 12-hour render — expect large disk usage per color if you let it run to completion. Interrupt with Ctrl+C between colors if you only need a subset; the script has no built-in early-exit or color-selection flag.
- Displayed color may differ from the named value depending on your screen's color profile — the description text embedded in each file's metadata says as much.

[↑ Back to README TOC](../README.md#table-of-contents)
