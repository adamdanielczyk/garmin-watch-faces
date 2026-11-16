# Mini Glyphs

An AMOLED-only letter-grid watch face. MIP and LCD displays are excluded to preserve
the grid's intended contrast and appearance.

## Display and settings

- Time rounds to the nearest five minutes: 10:32 → half past ten;
  10:33 → twenty-five to eleven.
- `BackgroundBrightness` affects unhighlighted letters only: 60% by default,
  100% full intensity, 0 hidden. Highlighted words retain the selected preset/custom color.
- Scheduled sleep hides background letters while retaining time words in their
  grid positions. Enabled by default through `EnableSleepModeLayout`, it follows
  local Garmin-profile sleep/wake times, including daylight-saving changes.
  Sleep time is inclusive and wake time exclusive; equal or unavailable times
  disable the layout.
- Device low power is independent of scheduled sleep. AMOLED always-on shows a
  compact rounded-time phrase in neutral gray with the native small font,
  alternating between separated upper/lower bands each minute. Waking restores
  the grid or scheduled-sleep layout.

## Compatibility

[manifest.xml](manifest.xml) lists supported products. For new devices, check
`displayType == "amoled"` and watch-face support in Garmin's `compiler.json`.
The [compatible-devices page](https://developer.garmin.com/connect-iq/compatible-devices/)
provides a public hardware cross-check.

Also check minimum API, compilation, grid readability, settings and sleep/AOD in
the simulator. Apply the [device support policy](../README.md#device-support-policy)
when reviewing new shapes, resolutions or watches with physical hands.

## Build and test

Use the repository [CLI setup](../README.md#development-setup) and
[verification workflow](../docs/verification.md):

```sh
./scripts/ciq test mini-glyphs venu3
```
