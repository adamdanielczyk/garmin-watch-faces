# Mini Chrono

## Device compatibility

Mini Chrono supports multiple display technologies, including AMOLED, MIP, and LCD. Its manifest includes round, semi-round, and rectangular watches. There is no general OLED-only or round-only restriction.

The current minimum API level is 2.1.0. Watches limited to older API levels are ineligible under that requirement, even if Garmin's SDK Manager downloads their definitions.

### Existing omissions requiring layout review

The manifest retains these semi-octagonal exclusions pending layout review:

- `descentg1`
- `instinct2`, `instinct2s`, `instinct2x`
- `instinct3solar45mm`
- `instinctcrossover`
- `instincte40mm`, `instincte45mm`

The original reason for these omissions is unconfirmed. They are consistent with a concern about unusual display geometry or cutouts, but have not been demonstrated to be incompatible. Retain these omissions until their layouts are checked explicitly. A successful compilation alone does not establish that the time remains visible.

### Legacy targets

`system8preview` was a System 8 beta test target and is excluded from production exports. `vivolife` is also excluded because its definition is unavailable in the current device library and SDK 9.3.0 rejects the ID. New packages no longer explicitly target it; no replacement target is assumed. Garmin has [acknowledged the missing definition](https://forums.garmin.com/developer/connect-iq/i/bug-reports/no-vivolife-device).

The exact supported product IDs remain in [manifest.xml](manifest.xml). See the [repository README](../README.md) for setup, build, and export commands.
