# Mini Index

A minimalist analog watch face: two hands and a black background, with no hour markers by default. No seconds hand, animation, data polling, network or sensor permissions.

Settings: sage/white/orange/blue minute-hand presets or a custom RGB color (each channel 0–255), no markers (default), four cardinal markers or all twelve hour markers, optional day of month. Date is off by default and is painted before the hands so the time remains visible when hands cross it. Hour hand advances with the minute, not only at the hour.

The default minute-hand color is orange, RGB `255, 153, 0` (`#FF9900`).

Enable **Use custom minute hand color** to apply the RGB values. Disable it to return to the selected preset; custom values are retained. AMOLED always-on remains neutral gray. MIP displays approximate custom RGB colors using the device palette.

## Display behavior

- Awake: full dial, optional date, selected accent. Native anti-aliasing smooths hands and markers on AMOLED/LCD devices where the API is available; other devices keep the existing rasterization.
- MIP low power: the same full dial, updated once per minute.
- AMOLED/LCD always-on: small gray analog dial, no markers when disabled, otherwise four markers, no date. Alternating top/bottom bands every minute extinguish the previous minute's pixels. This deliberate relocation supports older AMOLED screen protection as well as newer models.

## Compatibility

Supports **137 product IDs**, covering every watch in the installed Garmin device catalog with Connect IQ API 2.4 or newer. This includes all 129 products declared by Mini Chrono/Lingua plus eight monochrome Instinct/Descent products. Round, clipped-round, rectangular, AMOLED, LCD and MIP screens are included.

`monkey.jungle` explicitly selects display, monochrome and cutout profiles for every product from Garmin's device metadata. MIP retains its full dial in low power; AMOLED and LCD use the moving ambient dial. Monochrome models use white hands regardless of the saved color selection. Models with an upper-right sub-display use a smaller dial offset down and left to clear its bezel.

The remaining excluded watches only support Connect IQ 1.x: D2 Bravo/Titanium, original Epix, fēnix 3/3 HR, Forerunner 230/235/45/630/920XT, Garmin Swim 2 and original vívoactive. The implementation uses Application.Properties (API 2.4) and clipping APIs unavailable on those devices; supporting them requires a legacy API path. Non-watch devices are excluded because they do not support watch-face apps.

Run `python3 scripts/check-index-devices` from the repository root after updating Garmin device definitions. It flags newly available compatible watches missing from the manifest and incorrect display/cutout profiles. Use `--devices /path/to/Devices` on other SDK installations. Broad support is the default; any exclusion must have a documented technical or design reason.

## Build and test

From the repository root:

```sh
./scripts/ciq simulator
./scripts/ciq test mini-index venu3
./scripts/ciq run mini-index venu3
./scripts/ciq test mini-index fenix7
./scripts/ciq run mini-index fenix7
```

See [verification workflow](../docs/verification.md) and [implementation scope](../docs/implementation/glyphs-and-index.md). Submitted for Connect IQ Store review. [Store listing](https://apps.garmin.com/apps/71d8d765-534d-406b-97d9-532d3d5319c7).
