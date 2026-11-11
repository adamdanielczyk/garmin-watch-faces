# Connect IQ Store copy

Canonical listing text and the workflow for preparing Store assets.
Descriptions must fit Garmin’s 4,000-character limit.

| Face | Replacement description |
| --- | --- |
| Mini Chrono | [description.txt](../mini-chrono/store-assets/description.txt) |
| Mini Lingua | [description.txt](../mini-lingua/store-assets/description.txt) |
| Mini Glyphs | [description.txt](../mini-glyphs/store-assets/description.txt) |
| Mini Index | [description.txt](../mini-index/store-assets/description.txt) |

Each face has one complete description covering its implemented features. Verify
copy against its settings and renderer: Lingua uses English exact-minute text;
Glyphs uses English phrases rounded to five minutes and targets AMOLED displays.
Chrono and Lingua do not implement Index's moving ambient layout.

## Asset structure

Keep each face's Store materials in its own `store-assets/` directory. Preserve
final images and their native source captures alongside the code so future updates
can reuse the same framing and accurately reproduce the appearance.

| Path | Purpose |
| --- | --- |
| `README.md` | Listing link, image inventory, device/time/settings and reproduction steps |
| `title.txt` | Plain text to paste into the title field |
| `description.txt` | One complete, current description to paste into the Store |
| `cover.png` | Final cover image |
| `screen-<variant>.png` | Final screenshot, named for the settings it demonstrates |
| `raw/<device>-<variant>.png` | Original native capture before framing or resizing |
| `preview.png` | Optional comparison sheet for review, not upload |

Keep upload text free of Markdown wrappers or maintenance notes. Use Markdown for
README documentation. Record only the information needed to identify and regenerate
assets. Preserve established filenames and framing when updating a variant; use a
new descriptive name when adding one. Git history retains superseded assets once
committed, so parallel dated copies are unnecessary. Temporary experiments and
compiled packages belong in ignored `build/`.

Create image files and `raw/` when captures exist, rather than adding empty folders
or placeholders. Chrono, Lingua and Glyphs currently preserve listing text only;
Index provides a complete image example. The local check validates all four text
sets and Index's image set; extend it when adding curated images for another face.

## Store links

- [Mini Chrono](https://apps.garmin.com/apps/a76c8507-2093-4d44-b8fa-e8f30d6f8927)
- [Mini Lingua](https://apps.garmin.com/apps/6ba344de-c869-4ebe-9504-e8c7d2cc3320)
- [Mini Glyphs](https://apps.garmin.com/apps/0f1c6fae-9d28-4be9-909c-eaa7168f8276)
- [Mini Index](https://apps.garmin.com/apps/71d8d765-534d-406b-97d9-532d3d5319c7)

Mini Index images are in [store-assets](../mini-index/store-assets/README.md).
Their framing follows Mini Lingua's 500 × 500 cover and 500 × 524 previews,
with an enlarged case and short cropped strap sections. The native captures
remain at 10:08; reframing does not change application binaries.

## Prepare or revise images

1. Download the actual reference listing images. Compare their pixel dimensions,
   watch-case scale, strap crop and margins at the same displayed size. A screenshot
   of the listing explains the intent but is not the source image. Mini Lingua is
   the framing reference: cream Venu Sq 2 cover, black Venu 3 previews. The recipe
   is encoded in `scripts/prepare-index-store-assets`; reuse it instead of choosing
   a new crop. Show the watch case prominently with short sections of strap.
2. Choose a time that makes the design readable. Index uses 10:08: at 12:30 the
   nearly opposed hands make a narrow composition. Keep all variants at one time.
   The first three screenshots use date off and orange/none, sage/four, blue/twelve
   markers. The fourth uses custom lilac (#CC99FF), no markers and day 24.
   Distinguish markings on the physical bezel from configurable dial markers.
3. Capture the native renderer with deterministic inputs. `scripts/index-store-preview`
   copies production drawing code into ignored `build/store-preview/`, overrides
   time/settings, and uses a separate app ID. Use it only for screenshots; export
   production from `mini-index/`. Frozen input fixtures must not change geometry,
   fonts or rendering. Re-capture after drawing changes; framing-only changes can
   reuse the same raw PNGs.
4. Inspect the raw native image before compositing. Fix rendering defects in the
   application rather than retouching its screenshots. For thin diagonal hands,
   check native anti-aliasing, older API fallback and low-power behavior.
5. Compose with `python3 scripts/prepare-index-store-assets`; it checks the outputs.
   `--devices /path/to/Devices` selects another SDK device installation.
   For copy-only changes, run `python3 scripts/check-store-assets`.
6. Inspect every final image on both white and dark backgrounds, and compare the
   framing beside the downloaded reference. Check strap ends, edge specks, halos,
   simulator guide lines, hand edges and marker counts. Mechanical checks cannot
   judge these. A circular display needs an alpha mask so its square PNG corners
   do not cover the frame. Strip simulator guides from the frame only.
7. Run `python3 scripts/check-store-assets`. It checks canonical descriptions,
   native/final PNG dimensions, strict byte limits and asset privacy. Deliver
   only the cover and four individual screen PNGs for upload; `preview.png` is a
   review sheet. Completion requires visual inspection AND passing file checks.

## Write listing copy

Maintain one `description.txt` per face, covering its implemented features. Use
current user-provided release status; create version-specific copy only when asked.
Check settings, defaults, time formatting, languages, permissions and display modes
against that face's code. Describe capabilities plainly. Battery-life claims need
measurements; use Compatible Devices instead of implying every Garmin is supported.

## Export and handoff

- Rendering/source changes require a new production export and fresh visual evidence.
  Cropping, compression, text and README edits do not require rebuilding a submitted app.
- Export from the production project with `scripts/ciq`, then verify the final success and output path.
  Report both manifest product count and SDK build-variant count when relevant; they
  are different units, not two competing device-support totals.
- Keep production `.iq` files under ignored `build/<face>/`. The screenshot fixture
  `.prg` is never a release artifact. Record which source/rendering revision the
  handoff covers; earlier packages can become stale after a visual fix.
- Update the Store URL when the user supplies it, retaining the app's manifest ID.
  A Store listing UUID is not the manifest application UUID. Record submission as
  submission, and approval as approval, using the user's report or verified status.
- Upload only when instructed. Local builds and asset preparation do not publish.

## Automated coverage and limits

Run `python3 scripts/check-store-assets` locally before handing over Store assets.
It needs Python only, with no SDK or signing key. It catches oversized files, unexpected dimensions,
duplicate description variants, personal paths and embedded image text/EXIF metadata.

The SDK-dependent coverage check already exists: `scripts/check-index-devices`.
Run it locally after compatibility/device-catalog changes. Native simulation is
serial and interactive; the local asset check makes no claim to cover it. Geometry tests
prove their assertions, not complete rendered appearance or physical-watch behavior.

## Export privacy

Garmin `.iq` exports are compressed 7z packages. Searching the compressed bytes
misses paths in their source-map XML. SDK 9.3 retains those XML files even with
`monkeyc -e -r`; the release flag alone does not remove checkout paths.

`scripts/ciq export` copies the project to a neutral temporary path, builds with
`-e -r`, and runs `scripts/check-release-privacy` before copying the package into
`build/`. The check requires `bsdtar` (included on the verified macOS installation)
and inspects decompressed files for home/workspace paths and local identity strings.
Preserve the signed package as generated; editing or repacking its metadata is not the release process.
Generic source filenames and temporary build paths can remain in Garmin's source
maps. This check is specific to machine-path disclosure, not a general secret audit.
