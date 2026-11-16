# Connect IQ Store workflow

## Listing copy

Keep one complete `description.txt` per face, within Garmin's 4,000-character limit.

| Face | Description |
| --- | --- |
| Mini Chrono | [description.txt](../mini-chrono/store-assets/description.txt) |
| Mini Glyphs | [description.txt](../mini-glyphs/store-assets/description.txt) |
| Mini Index | [description.txt](../mini-index/store-assets/description.txt) |
| Mini Lingua | [description.txt](../mini-lingua/store-assets/description.txt) |

Check claims against settings and rendering: Lingua uses English exact-minute
text; Glyphs uses English five-minute phrases and is AMOLED-only. Chrono and
Lingua lack Index's moving ambient layout. Verify defaults, languages, permissions
and display modes. Battery-life claims require measurements; refer users to
Compatible Devices rather than implying universal support.

Use current release status supplied by the user or verified in the Store.
Submission does not establish approval. Create version-specific copy only when
requested. Upload text contains no Markdown wrappers or maintenance notes.

## Asset structure

Keep each face's assets in its `store-assets/` directory:

| Path | Purpose |
| --- | --- |
| `README.md` | Listing link, image inventory and capture/reproduction details |
| `title.txt`, `description.txt` | Copy to paste into the Store |
| `cover.png` | Cover image |
| `screen-<variant>.png` | Individual upload screenshot |
| `raw/<device>-<variant>.png` | Original native capture |
| `preview.png` | Optional comparison sheet; exclude from upload |

Preserve filenames and framing when updating variants; Git retains old versions.
Create image folders when captures exist. Chrono/Lingua currently contain text
only; Glyphs/Index include curated images and captures. Their asset READMEs record
variants and reproduction commands: [Glyphs](../mini-glyphs/store-assets/README.md),
[Index](../mini-index/store-assets/README.md).

## Screenshot conventions

- Time: 12:30, except Index at 10:08 to separate its hands.
- Cover: orange preset, cream Venu Sq 2, 500 × 500.
- Screenshots: black Venu 3, 500 × 524, enlarged case and short cropped straps.
- [Mini Lingua](https://apps.garmin.com/apps/6ba344de-c869-4ebe-9504-e8c7d2cc3320)
  is the framing reference. Compare downloaded source images, not screenshots
  of the listing, for dimensions, case scale, crop and margins.

## Prepare or revise images

1. Follow the face's asset README for device, time and variant settings. Capture
   through its isolated `scripts/*-store-preview` fixture, which fixes inputs and
   uses a separate app ID under ignored `build/`. Preserve production drawing
   code, fonts and geometry. Export releases from the production project.
2. Save native PNGs in `raw/`. Re-capture after drawing changes; framing-only edits
   may reuse existing captures. For capture problems, use
   [simulator recovery](verification.md#recover-from-simulatorui-failures).
3. Inspect raw images. Fix rendering defects in the app rather than retouching
   face pixels. Check thin diagonals, native anti-aliasing, older-API fallback and
   low-power rendering where affected.
4. Run the face's `scripts/prepare-*-store-assets` command. Composition removes
   frame guides/white canvas, masks round screens and applies the shared crop.
   `--devices /path/to/Devices` selects another device installation.
5. Inspect final images on light and dark backgrounds beside the reference.
   Check strap edges, halos, guides, hand edges and markers. Physical bezel
   markings are independent of configurable dial markers.
6. Run `python3 scripts/check-store-assets`. Deliver the cover and four individual
   screenshots; keep `preview.png` as a review sheet.

For text-only changes, run just the asset check. It requires Python, not an SDK or
key, and checks all four text sets plus the two curated image sets for file limits,
dimensions and private metadata. Extend coverage when adding other image sets.
Passing file checks does not replace visual inspection or native validation.

## Export and handoff

- Source changes require a production export; rendering changes also require
  fresh visual evidence. Text, framing and compression edits need no app rebuild.
- Run `./scripts/ciq export <face>` and confirm success/output. Packages stay under
  ignored `build/<face>/`; screenshot-fixture executables are never release artifacts.
- Identify the source revision covered. When reporting coverage, distinguish
  manifest product count from SDK build variants.
- Preserve manifest IDs when updating Store URLs: Store UUIDs and app UUIDs differ.
- Upload only on the user's instruction.

Device/catalog changes also need the checks in
[verification](verification.md#coverage-policy).

## Export privacy

Garmin `.iq` files are compressed 7z packages. SDK 9.3 retains source-map XML with
checkout paths even under `monkeyc -e -r`; searching compressed bytes misses them.

`ciq export` builds from a neutral temporary directory and runs
`scripts/check-release-privacy` on decompressed contents before copying the package
to `build/`. This requires `bsdtar` and checks private paths/identity strings, not
all possible secrets. Generic filenames and temporary paths may remain. Preserve
the signed package as generated rather than repacking its metadata.
