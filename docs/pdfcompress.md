# `pdfcompress`

[← Back to README](../README.md#table-of-contents)

`pdfcompress` batch-compresses PDF files and keeps the originals.

## What It Does

- takes one or more PDF filenames as arguments
- shows the file list and a count, then waits for confirmation before doing anything
- compresses each PDF via `qpdf --linearize` piped into `pdftk ... compress`
- moves the original (pre-compression) copies into an `orig/` subfolder

## Supported Platforms

- macOS
- Linux

## Dependencies

- `qpdf`
- `pdftk`

## Install / First Run Summary

Install `qpdf` and `pdftk` via your package manager first, then run against one or more files:

```bash
pdfcompress file1.pdf file2.pdf
```

## Common Usage Examples

Compress every PDF in the current directory:

```bash
pdfcompress *.pdf
```

Compress a single file:

```bash
pdfcompress report.pdf
```

## Important Behavior / Defaults

- Requires at least one filename argument — running it with none prints a short message and exits.
- Prompts once with a file list and count, then waits for Enter (or Ctrl+C to cancel) before compressing.
- Originals end up in `./orig/` (created if it doesn't exist yet); the compressed file replaces the original filename in place.

## Notes / Caveats

- Compression happens via a temporary `.uncompressed` copy of each file in the current directory before the move into `orig/` — don't rely on filenames matching `*.pdf.uncompressed` for anything else while this is running.
- No dry-run mode; review the file list shown at the confirmation prompt before pressing Enter.

[↑ Back to README TOC](../README.md#table-of-contents)
