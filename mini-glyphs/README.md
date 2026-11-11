# Mini Glyphs

## Device compatibility

Mini Glyphs targets AMOLED watches. This is an intentional visual constraint: the letter grid is intended to remain clearly readable with the appearance provided by OLED displays. MIP and LCD watches are excluded from this face.

When considering new devices, use Garmin's downloaded `compiler.json` metadata to check `displayType == "amoled"` and watch-face support. [Garmin's compatible-devices page](https://developer.garmin.com/connect-iq/compatible-devices/) provides a public cross-check for screen technology, shape, resolution, and API level.

AMOLED alone does not establish compatibility. Check the manifest's minimum API requirement, compile for the target, and verify the letter grid, contrast, settings, and sleep/always-on behavior in the simulator. New resolutions, screen shapes, and watches with physical hands need particular visual attention.

## Sleep layout

The sleep layout is enabled by default. During the sleep interval configured in the user's Garmin profile, background letters disappear while the highlighted time words remain. This follows the profile's sleep/wake times and the `EnableSleepModeLayout` setting, independently of the display's high-power or always-on mode. If profile sleep/wake times are unavailable, the normal layout remains active.

The exact supported product IDs remain in [manifest.xml](manifest.xml). See the [repository README](../README.md) for setup, build, and export commands.

## Contrast and always-on refinement

`BackgroundBrightness` scales only background letters: default 60%, 100% uses full intensity, and 0 hides them. Existing presets, RGB values, settings keys and application ID are preserved. The highlighted words keep their selected color.

Scheduled sleep still shows highlighted words in their grid positions. Its interval is inclusive at the configured sleep time and exclusive at wake time; equal or unavailable times disable it. It uses local clock time, including on daylight-saving transitions.

Device low power is independent: AMOLED always-on shows a compact rounded-time phrase in neutral gray, using the device's native small font. It alternates between separated upper/lower bands each minute; it does not rely on a tiny pixel shift to prevent static pixels. Leaving low power restores the grid or the scheduled-sleep layout as appropriate. Rounding remains to the nearest five minutes (e.g. 10:32 → half past ten; 10:33 → twenty-five to eleven).

Native tests run with `./scripts/ciq test mini-glyphs venu3`. See [verification workflow](../docs/verification.md) for repeatable simulator checks and limitations.
