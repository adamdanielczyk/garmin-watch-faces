# Mini Glyphs Store assets

[Connect IQ listing](https://apps.garmin.com/apps/0f1c6fae-9d28-4be9-909c-eaa7168f8276)

## Upload files

- [title.txt](title.txt): Store title.
- [description.txt](description.txt): complete listing description.
- [cover.png](cover.png): cream Venu Sq 2, orange, 500 × 500.

The four screenshots use the black Venu 3 at 12:30 (HALF PAST TWELVE),
with the same enlarged 500 × 524 framing as Mini Index.

| Screenshot | Preset | Background brightness |
| --- | --- | --- |
| [Orange](screen-orange.png) | Orange | 60% (default) |
| [Blue](screen-blue.png) | Blue | 60% |
| [Green](screen-green.png) | Green | 60% |
| [Pink, background hidden](screen-pink-hidden.png) | Pink | 0% |

[preview.png](preview.png) is a comparison sheet for review, not upload.

## Source and framing

[raw/](raw/) contains native Connect IQ simulator captures. Production fonts,
geometry and rendering are unchanged. The isolated fixture fixes time, preset,
background brightness, disables scheduled sleep and custom colors, and seeds
random filler letters with 7. The hidden-background example uses the normal
awake layout with background brightness 0; it is not always-on mode.

Composition reuses Mini Index's Garmin simulator frames and crop: cream square
Venu Sq 2 cover, black round Venu 3 previews, prominent case and short straps.
Only frame guides and the connected white canvas are removed; native face pixels
are not retouched. The circular face receives an alpha mask before composition.

## Reproduce

From the repository root, start the simulator and load a screenshot fixture:

```sh
python3 scripts/glyphs-store-preview venu3 orange
```

Variants: `orange`, `blue`, `green`, `pink-hidden`. Capture each Venu 3 variant;
use `venusq2 orange` for the cover. Save the native display through the simulator's
File → Save Screen Capture menu to `raw/<device>-<variant>.png`, then run:

```sh
python3 scripts/prepare-glyphs-store-assets
python3 scripts/check-store-assets
```

Requires the Garmin SDK, installed device frames and ImageMagick. The fixture uses
a separate application ID and writes only to ignored `build/glyphs-store-preview/`;
release builds come from the production project. Screenshots do not require a new
production package. See the [Store workflow](../../docs/store-listings.md) and
[capture recovery](../../docs/verification.md#recover-from-simulatorui-failures).
