# Agent instructions

## Project boundaries

Treat each `mini-*` directory as an independent Connect IQ application. Classes with the same name in different projects are separate implementations. Keep changes within the requested face unless a shared tooling change is needed.

Preserve application IDs in `manifest.xml`, Store links, and persisted settings keys during maintenance. Device support, languages, and permissions are specific to each manifest; review their differences before applying a change across faces.

Before changing device support, read the affected face's README for display constraints, existing omissions, and unresolved compatibility decisions. Update those notes when the compatibility policy changes.

## Build and validate

Use the command-line workflow in [README.md](README.md). Run `./scripts/ciq doctor` to check local setup. SDK Manager discovery and the ignored `.ciq.local.json` supply local paths without an IDE. Builds need write access to Garmin's installed SDK/data directories as well as the repository. Build each affected face for an installed, supported device. For layout changes, also run the simulator on representative affected screen sizes and display types and check settings and sleep behavior.

The imported projects have no automated Monkey C tests. Distinguish successful compilation from simulator or physical-watch verification. If the SDK, device definitions, or signing key is unavailable, report the missing prerequisite and the checks that could not run.

Keep developer keys outside the repository and generated artifacts under the ignored `build/` directory. Exporting produces a local package; Store uploads require the user's explicit instruction.
