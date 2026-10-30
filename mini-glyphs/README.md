# Mini Glyphs

## Device compatibility

Mini Glyphs targets AMOLED watches. This is an intentional visual constraint: the letter grid is intended to remain clearly readable with the appearance provided by OLED displays. MIP and LCD watches are excluded from this face.

When considering new devices, use Garmin's downloaded `compiler.json` metadata to check `displayType == "amoled"` and watch-face support. [Garmin's compatible-devices page](https://developer.garmin.com/connect-iq/compatible-devices/) provides a public cross-check for screen technology, shape, resolution, and API level.

AMOLED alone does not establish compatibility. Check the manifest's minimum API requirement, compile for the target, and verify the letter grid, contrast, settings, and sleep/always-on behavior in the simulator. New resolutions, screen shapes, and watches with physical hands need particular visual attention.

## Sleep layout

The sleep layout is enabled by default. During the sleep interval configured in the user's Garmin profile, background letters disappear while the highlighted time words remain. This follows the profile's sleep/wake times and the `EnableSleepModeLayout` setting, independently of the display's high-power or always-on mode. If profile sleep/wake times are unavailable, the normal layout remains active.

The exact supported product IDs remain in [manifest.xml](manifest.xml). See the [repository README](../README.md) for setup, build, and export commands.
