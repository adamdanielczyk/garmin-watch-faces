# Mini Index

A minimalist analog face: two hands on black, no seconds or animation. The hour
hand advances with each minute. No data polling, network or sensor permissions.

## Settings

- Minute hand: sage, white, orange (default `#FF9900`) or blue; custom RGB channels
  accept 0–255. **Use custom minute hand color** selects custom values; disabling
  it restores the preset while retaining RGB settings. MIP approximates colors
  with its device palette; AMOLED always-on stays neutral gray.
- Markers: none (default), four cardinal or twelve.
- Day of month: off by default, drawn behind the hands to preserve the time.

## Display behavior

- Awake: full dial, optional date and selected accent; native anti-aliasing on
  AMOLED/LCD where supported, existing rasterization elsewhere.
- MIP low power: full dial, updated once per minute.
- AMOLED/LCD always-on: small gray dial, no date, none or four markers. It switches
  between separated top/bottom bands each minute for screen protection.

## Compatibility

[manifest.xml](manifest.xml) lists 128 products with API 2.4+, covering round,
clipped-round and rectangular AMOLED/LCD/MIP screens. Small conventional displays
remain eligible. `monkey.jungle` selects display/monochrome/cutout profiles from
Garmin metadata. Instinct 3 AMOLED subscreens are virtual, so both sizes use the
normal centered dial.

Nine products are design exclusions, recorded in `device-exclusions.json`:

- Physical cutouts: `descentg1`, `instinct2`, `instinct2s`, `instinct2x`,
  `instinct3solar45mm`, `instincte40mm`, `instincte45mm`. Avoiding the cutout requires
  a reduced offset dial: on 176px Solar, roughly 48px radius with 27px/40px hands,
  smaller still on other models. This compromises the full-dial design.
  `instinct3solar45mm` covers both 45mm and 50mm Solar models.
- Hybrids: `instinctcrossover`, `instinctcrossoveramoled`. Physical hands/hub obscure
  digital hands; there is no hybrid renderer.

The reported Solar fit problem was observed as an undersized offset layout, not
reproduced clipping. These exclusions do not imply Connect IQ cannot run on the
hardware. Restoring support requires an explicitly reviewed alternative layout.

API 1.x watches are excluded: D2 Bravo/Titanium, original Epix, fēnix 3/3 HR,
Forerunner 230/235/45/630/920XT, Garmin Swim 2 and original vívoactive. Supporting
them requires replacements for Application.Properties (API 2.4) and clipping APIs.
Non-watch devices cannot run watch-face apps.

Follow the [device support policy](../README.md#device-support-policy). After SDK
device updates, run `python3 scripts/check-index-devices` to catch unreviewed
entries, unsupported hardware and profile drift. Validate the existing layout or
record an exclusion; update `device-exclusions.json`. Use
`--devices /path/to/Devices` for another device installation.

## Known limitation

Some simulator frames lose static marker pixels after toggling MIP Sleep Mode;
others are complete. Capture versus rendering behavior remains unresolved.
A complete frame or passing geometry test does not prove a fix; repeatable
simulator and physical-watch checks are needed.

## Build and test

From the repository root, with the simulator running:

```sh
./scripts/ciq test mini-index venu3
./scripts/ciq test mini-index fenix7
./scripts/ciq run mini-index venu3
```

See [verification](../docs/verification.md). Available in the Connect IQ Store:
[listing](https://apps.garmin.com/apps/71d8d765-534d-406b-97d9-532d3d5319c7).
