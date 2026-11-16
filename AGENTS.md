# Agent instructions

## Project boundaries

Each `mini-*` directory is an independent Connect IQ app, including classes with
the same name. Keep changes within the requested face unless shared tooling needs
an update. Preserve manifest application IDs, Store links and persisted settings
keys; devices, languages and permissions differ between faces.

For device additions, SDK updates or fit reports, read the affected face's README
and follow the [device support policy](README.md#device-support-policy). Update its
compatibility notes when decisions change. Preserve Glyphs' AMOLED-only policy;
run `python3 scripts/check-index-devices` after Index device/profile changes.

## Build and validate

Use the [CLI workflow](README.md#development-setup), starting with
`./scripts/ciq doctor`. Builds need write access to Garmin's SDK/data directories.
Build each affected face on an installed, supported device. For layout changes,
check representative screen sizes/display types, settings and sleep behavior.

Run `./scripts/ciq test <face> <device>` with the simulator running; simulator jobs
must be sequential. All faces have review-scheduling tests; Glyphs and Index also
have rendering tests. [Verification](docs/verification.md) covers settings transfer,
captures, burn-in and recovery. Read its recovery section before repeating a failed
simulator UI action. Report compilation, simulator and physical-watch results
separately, including missing prerequisites and checks that could not run.

Keep keys outside the repository and generated artifacts under ignored `build/`.
Curated Store images, native captures and copy belong in each face's `store-assets/`.
For screenshots, listing copy or release handoff, follow the
[Store workflow](docs/store-listings.md); run `python3 scripts/check-store-assets`
after asset/copy edits. Export makes a local package; Store uploads require the
user's explicit instruction.

## Documentation

Document current setup, workflows, decisions and limitations. Keep conversation
history and temporary logs out of tracked docs; use relative paths or generic
placeholders in examples.
