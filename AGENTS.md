# Agent instructions

## Project boundaries

Treat each `mini-*` directory as an independent Connect IQ application. Classes with the same name in different projects are separate implementations. Keep changes within the requested face unless a shared tooling change is needed.

Preserve application IDs in `manifest.xml`, Store links, and persisted settings keys during maintenance. Device support, languages, and permissions are specific to each manifest; review their differences before applying a change across faces.

Before changing device support, read the affected face's README for display constraints, existing omissions, and unresolved compatibility decisions. Update those notes when the compatibility policy changes.

Support all compatible watch products by default. Representative test devices are not a release compatibility limit. Document concrete API, hardware or design reasons for exclusions; preserve Glyphs’ intentional AMOLED-only policy. For Mini Index, run `python3 scripts/check-index-devices` after SDK/device updates to catch coverage and display-profile drift.

## Build and validate

Use the command-line workflow in [README.md](README.md). Run `./scripts/ciq doctor` to check local setup. SDK Manager discovery and the ignored `.ciq.local.json` supply local paths without an IDE. Builds need write access to Garmin's installed SDK/data directories as well as the repository. Build each affected face for an installed, supported device. For layout changes, also run the simulator on representative affected screen sizes and display types and check settings and sleep behavior.

Glyphs and Index have native tests: run `./scripts/ciq test <face> <device>` with the simulator running. Run simulator jobs sequentially. See [verification workflow](docs/verification.md) for settings-schema transfer, captures and burn-in checks. Chrono and Lingua do not yet have native tests. Distinguish successful compilation from simulator or physical-watch verification. If the SDK, device definitions, or signing key is unavailable, report the missing prerequisite and the checks that could not run.

Keep developer keys outside the repository and compiled/test artifacts under the ignored `build/` directory. Curated Store images, native source captures and copy belong in each face’s `store-assets/`. Exporting produces a local package; Store uploads require the user's explicit instruction.

For Store screenshots, framing, listing copy or release handoff, read [Store workflow](docs/store-listings.md). Run `python3 scripts/check-store-assets` after asset/copy edits. For simulator UI failures, read the recovery section in [verification](docs/verification.md) before retrying the same action.

## Documentation

Write concise documentation for users and maintainers: setup, workflows, useful
design decisions and known limitations. Describe the current project rather than
the development conversation. Use relative paths or generic placeholders in
examples; keep local configuration and temporary logs outside tracked docs.
