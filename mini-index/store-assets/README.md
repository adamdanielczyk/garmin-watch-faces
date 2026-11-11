# Mini Index Store assets

[Connect IQ listing](https://apps.garmin.com/apps/71d8d765-534d-406b-97d9-532d3d5319c7)

## Upload files

- [title.txt](title.txt): Store title.
- [description.txt](description.txt): complete listing description.
- [cover.png](cover.png): cream Venu Sq 2, 500 × 500.

The four screenshots use the black Venu 3 at 10:08, with the same 500 × 524 framing.

| Screenshot | Minute hand | Dial markers | Date |
| --- | --- | --- | --- |
| [Orange](screen-orange-none.png) | `#FF9900` | None | Hidden |
| [Sage](screen-sage-four.png) | `#99CCBB` | Four | Hidden |
| [Blue](screen-blue-twelve.png) | `#99CCFF` | Twelve | Hidden |
| [Lilac with date](screen-lilac-none-date.png) | Custom `#CC99FF` | None | 24 |

Physical bezel markings belong to the watch, independently of the dial setting.
[preview.png](preview.png) is a comparison sheet for review, not a Store upload.

## Source and framing

[raw/](raw/) contains native Connect IQ simulator captures with fixed time and
settings. Composition uses Garmin's installed simulator frames: cream Venu Sq 2
for the cover and black Venu 3 for screenshots. Hands, fonts and dial elements
come from the production renderer, without retouching.

Framing follows [Mini Lingua](https://apps.garmin.com/apps/6ba344de-c869-4ebe-9504-e8c7d2cc3320):
an enlarged case with short cropped strap sections. Composition removes the frame's
white canvas and simulator guides, masks the circular screen and resizes the result.

## Reproduce

From the repository root, run the fixture for the desired device and variant:

```sh
python3 scripts/index-store-preview venu3 lilac-none-date
```

Variants are `orange-none`, `sage-four`, `blue-twelve` and `lilac-none-date`.
Use `venusq2 orange-none` for the cover. Save the native screen capture as
`raw/<device>-<variant>.png`, then compose and validate:

```sh
python3 scripts/prepare-index-store-assets
python3 scripts/check-store-assets
```

Composition requires installed Garmin device frames and ImageMagick. The fixture
has a separate application ID and is only for screenshots; release builds come
from the production project. For text-only edits, run just the asset check.

See the shared [Store workflow](../../docs/store-listings.md) for file limits and
[verification guide](../../docs/verification.md) for simulator capture recovery.
