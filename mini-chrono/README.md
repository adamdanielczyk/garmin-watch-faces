# Mini Chrono

## Device compatibility

Supports AMOLED, MIP and LCD displays on round, semi-round and rectangular watches.
Minimum API: 2.1.0. [manifest.xml](manifest.xml) lists supported products.

These existing omissions remain pending layout review:

- `descentg1`
- `instinct2`, `instinct2s`, `instinct2x`
- `instinct3solar45mm`
- `instinctcrossover`
- `instincte40mm`, `instincte45mm`

Their original rationale is unconfirmed; unusual geometry/cutouts are a possible
explanation, not demonstrated incompatibility. Retain the omissions until native
layout checks establish support. Verify time visibility, settings and sleep behavior. Compilation alone is insufficient.

## Legacy targets

`system8preview` was a beta target. `vivolife` is excluded because its definition is
unavailable and SDK 9.3.0 rejects the ID; no replacement is assumed.
[Garmin issue](https://forums.garmin.com/developer/connect-iq/i/bug-reports/no-vivolife-device).

See the repository [CLI setup](../README.md#development-setup) and
[device support policy](../README.md#device-support-policy).
