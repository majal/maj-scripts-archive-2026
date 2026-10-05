# `pdfind`

[← Back to README](../README.md#table-of-contents)

`pdfind` is a graphical (Zenity) tool to search for text inside every PDF in the current directory and jump straight to the matching page.

## What It Does

- prompts for a search string (regex supported) via a Zenity dialog, pre-filled with your last search
- searches every `*.pdf` in the current directory with `pdfgrep`, showing a progress dialog while it works
- lists matches (filename, page, surrounding text) in a Zenity list dialog
- opens the file you pick with `evince`, jumped to the matching page and search term highlighted

## Supported Platforms

- Linux (desktop, GTK dialogs)

## Dependencies

- `zenity`, `pdfgrep` (required)
- `evince` (optional — only needed to open a result directly from the tool)

## Install / First Run Summary

Install `zenity` and `pdfgrep` (and `evince` if you want click-to-open), then run it from the folder you want to search:

```bash
cd ~/Documents/reports
pdfind
```

It's also suited to wiring up as a Nautilus (Files) right-click action on a folder.

## Common Usage Examples

Search the current directory interactively:

```bash
pdfind
```

Re-run with the same search term pre-filled — just accept the dialog's default text, which is whatever you searched last time in this directory.

## Important Behavior / Defaults

- Only searches the current working directory (non-recursive `find -name '*.pdf'` at depth from where it's run).
- Remembers your last search term in `pdfind.last`, written next to the script itself — not per-directory.
- Cancelling the dialog or leaving the search box empty shows a warning and exits without searching.

## Notes / Caveats

- `pdfind.last` is local runtime state, not meant to be tracked in git or synced.
- This is a Linux-desktop tool by design (Zenity/GTK dialogs, Evince) — there's no macOS or headless equivalent here.

[↑ Back to README TOC](../README.md#table-of-contents)
