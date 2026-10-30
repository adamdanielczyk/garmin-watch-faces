# Garmin Watch Faces

Source code for Mini Chrono, Mini Lingua, and Mini Glyphs, published on the Garmin Connect IQ Store.

| Watch face | Source | Download |
| --- | --- | --- |
| Mini Chrono | [mini-chrono](mini-chrono/) | [Connect IQ Store](https://apps.garmin.com/en-US/apps/a76c8507-2093-4d44-b8fa-e8f30d6f8927) |
| Mini Lingua | [mini-lingua](mini-lingua/) | [Connect IQ Store](https://apps.garmin.com/en-US/apps/6ba344de-c869-4ebe-9504-e8c7d2cc3320) |
| Mini Glyphs | [mini-glyphs](mini-glyphs/) | [Connect IQ Store](https://apps.garmin.com/en-US/apps/0f1c6fae-9d28-4be9-909c-eaa7168f8276) |

Each folder is an independent Monkey C project with its own `manifest.xml`, `monkey.jungle`, `source/`, and `resources/`. Supported watches are listed in that project's manifest.

Each project's README documents its display constraints, existing device omissions, and compatibility checks: [Chrono](mini-chrono/README.md), [Lingua](mini-lingua/README.md), and [Glyphs](mini-glyphs/README.md).

## Development setup

The workflow uses the command line and works without an IDE.

1. Install Python 3.9 or newer for this repository's CLI helper. It uses only the Python standard library. Garmin's compiler and simulator loader run on Java; install a Java runtime supported by your SDK. Java 21 has been verified with SDK 9.3.0 for these projects.
2. Install [Garmin's Connect IQ SDK Manager](https://developer.garmin.com/connect-iq/sdk/), then use it to download an SDK and the device definitions you need.
3. Create a local `.ciq.local.json` file with the path to your existing signing key:

   ```json
   {
     "developerKey": "/absolute/path/outside/this/repository/developer_key"
   }
   ```

The helper discovers the active SDK from the SDK Manager's `current-sdk.cfg` on macOS and Linux. For another SDK location, add an `sdk` path to the local JSON file. `CIQ_SDK` and `CIQ_DEVELOPER_KEY` environment variables override local configuration. If no SDK is configured or discovered, the helper looks for Garmin's tools on `PATH`.

`.ciq.local.json` is ignored by Git. Keep the key itself outside this repository. Use your existing developer key when preparing updates to the published watch faces; generating a new development key is unnecessary when you already have one.

Check the setup before building:

```sh
./scripts/ciq doctor
```

This checks Python, Java, the compiler, simulator launch tools, and signing-key presence. A successful build is still needed to verify that the key is valid and the selected device definition is installed. Agents running with filesystem restrictions need access to Garmin's SDK and data directories: the compiler generates SDK files even when the project output is inside this repository.

See Garmin's [command-line setup guide](https://developer.garmin.com/connect-iq/reference-guides/monkey-c-command-line-setup/) for SDK setup and generating a development key with OpenSSL.

## Build and run

Run these commands from the repository root. The examples use `venu3`, which is supported by all three projects; its device definition must be installed in the SDK Manager.

```sh
# List a project's supported product IDs; no SDK or signing key needed.
./scripts/ciq devices mini-chrono

# Build one watch face for one device.
./scripts/ciq build mini-chrono venu3
./scripts/ciq build mini-lingua venu3
./scripts/ciq build mini-glyphs venu3
```

Builds are written to `build/<face>/<device>.prg`. To preview a watch face, start the simulator in one terminal, then build and load it from another:

```sh
./scripts/ciq simulator
```

```sh
./scripts/ciq run mini-chrono venu3
```

The `run` command rebuilds before loading the app and stays attached to the simulator session. Use Ctrl-C to detach the terminal. In the simulator, check the rendered time, settings, and sleep behavior. For changes affecting device layouts, check the affected screen sizes and display types as well.

## Export

```sh
./scripts/ciq export mini-chrono
```

This invokes Garmin's compiler in export mode for the project's manifest targets and writes `build/mini-chrono/mini-chrono.iq`. Install the required device definitions first. Export creates a local package; upload it separately to the existing Store listing after review.

The manifests exclude the former `system8preview` beta target and the unavailable `vivolife` definition. Per-face READMEs document compatibility exclusions.

## Working with agents

[AGENTS.md](AGENTS.md) describes project boundaries and validation expectations. There is no automated Monkey C test suite in the imported projects. Compilation checks and simulator checks should be reported separately.
