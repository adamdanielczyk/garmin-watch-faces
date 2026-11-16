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

Supports **128 product IDs** from the installed Garmin device catalog with Connect IQ API 2.4 or newer, including round, clipped-round, rectangular, AMOLED, LCD and MIP screens. Small full displays remain supported; display size alone is not an exclusion.

`monkey.jungle` explicitly selects display, monochrome and cutout profiles from Garmin's device metadata. MIP retains its full dial in low power; AMOLED and LCD use the moving ambient dial. Instinct 3 AMOLED's sub-display is virtual, so both sizes use the full centered dial.

Nine products are intentionally excluded for this analog design (machine-readable reasons in `device-exclusions.json`):

- Physical cutouts: `descentg1`, `instinct2`, `instinct2s`, `instinct2x`, `instinct3solar45mm`, `instincte40mm`, `instincte45mm`. Avoiding the upper-right sub-display and bezel requires a reduced, offset dial. On the 176px Solar display its radius is about 48px, with a 27px hour hand and 40px minute hand; smaller models are tighter. This compromises the intended full-dial appearance and readability. Garmin's `instinct3solar45mm` target covers **both 45mm and 50mm Solar models**.
- Hybrid watches: `instinctcrossover`, `instinctcrossoveramoled`. Physical hands and the central hub cover the digital analog hands; there is no hybrid-specific renderer.

These are design exclusions, not claims that the devices cannot run Connect IQ or that clipping was reproduced. The reported Solar “doesn't fit” symptom was not reproduced as literal clipping in the simulator; the small offset layout was observed. Restoring support requires an explicitly reviewed alternative layout.

The remaining excluded watches only support Connect IQ 1.x: D2 Bravo/Titanium, original Epix, fēnix 3/3 HR, Forerunner 230/235/45/630/920XT, Garmin Swim 2 and original vívoactive. The implementation uses Application.Properties (API 2.4) and clipping APIs unavailable on those devices; supporting them requires a legacy API path. Non-watch devices are excluded because they do not support watch-face apps.

Follow the repository's [device support policy](../README.md#device-support-policy). Run `python3 scripts/check-index-devices` after updating Garmin device definitions. It flags unreviewed catalog entries, unsupported hardware in the manifest and incorrect display/cutout profiles. Resolve new entries through a documented exclusion or validation of the existing layout; automatic inclusion is not required. Use `--devices /path/to/Devices` on other SDK installations. Record exclusions in `device-exclusions.json`.

## Known limitation

Some simulator frames omit static marker pixels after toggling MIP Sleep Mode;
other frames are complete. The cause remains unresolved and has not been isolated
to capture behavior or device rendering. A later complete frame or passing geometry
test does not establish a fix; repeatable simulator and physical-watch checks are needed.

## Build and test

From the repository root:

```sh
./scripts/ciq simulator
./scripts/ciq test mini-index venu3
./scripts/ciq run mini-index venu3
./scripts/ciq test mini-index fenix7
./scripts/ciq run mini-index fenix7
```

See [verification workflow](../docs/verification.md). Submitted for Connect IQ Store review. [Store listing](https://apps.garmin.com/apps/71d8d765-534d-406b-97d9-532d3d5319c7).
