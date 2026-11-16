# Native verification workflow

Use Garmin's SDK and simulator for fonts, settings callbacks, display profiles and
screen protection. Browser previews cannot establish native behavior.

## Build and regression tests

```sh
./scripts/ciq doctor
./scripts/ciq simulator
./scripts/ciq test mini-chrono venu3
./scripts/ciq test mini-glyphs venu3
./scripts/ciq test mini-index venu3
./scripts/ciq test mini-index fenix7
./scripts/ciq test mini-lingua venu3
./scripts/ciq run mini-index venu3
```

Run simulator jobs sequentially. `test` compiles with `--unit-test`, runs
`monkeydo -t` and saves `build/<face>/<device>/tests/<device>-tests.log`. It requires
an explicit non-empty passing summary: SDK 9.3 may return status 1 even when tests
pass. A timeout leaves a failure marker in the log.

All faces test the initial two-week/14-usage-day wait, repeated wakes, retry
throttling, four/eight/twelve-week spacing, saved state and clock rollback.
Keep their independent `ReviewPrompt.mc` implementations and tests aligned.

### Review-screen smoke test

**Settings → Review Requests → Grant / Deny / Fail** controls simulator token
responses. Use an isolated copy under ignored `build/` with a separate app ID.
Seed `reviewScheduleV1` with `days = 14`, `nextAt = 0`, `attemptAt = 0`, `shown = 0`
and the current UTC day as `lastDay`. Keep production timing unchanged.

Test during daytime with the simulated phone connected and Do Not Disturb off.
Grant should open Garmin's review UI; Deny/Fail should leave the dial visible.
Automated scheduling tests do not submit Store reviews.

### Settings transfer and old executable names

Executables use `build/<face>/<device>/<face>.prg`; test programs use the same name
under `tests/`. `run` transfers the settings JSON with `monkeydo -a`. The settings
editor loads Garmin's hosted UI and requires network access.

The simulator may retain the first executable name associated with an app ID,
even after restarting. If it originally loaded as `VENU3.PRG`, refresh that schema:

```sh
./scripts/ciq run mini-glyphs venu3 --settings-alias VENU3
```

Use only the app's known original stem. The alias refreshes that JSON directly:
SDK 9.3 cached old content when uploaded twice with `-a`. Avoid editing apps with
colliding old names together; preserve other apps' data when repairing a schema.

## Visual checklist

1. Load each representative target and confirm the device title and rendered face.
2. Set deterministic time through **Simulation → Time Simulation**. Glyphs:
   00:00, 11:58, 10:32, 10:33, 10:25. Index: 12:00, 03:15, 06:30, 10:08.
   Speed up to inspect transitions; stop simulation before returning to live time.
3. Change settings through **File → Edit Persistent Storage → Edit Application.Properties data**.
   Select the correct app, save, wait for **Settings Saved**, acknowledge it, then
   close and inspect. Closing early may leave old values active. Check:
   - Glyphs: background 0/60/100, preset/custom colors, scheduled-sleep preference.
   - Index: none/four/twelve markers, date, preset/custom RGB. In AMOLED always-on,
     None stays empty and Four/Twelve show four markers.
4. Use **Settings → Set User Profile** to check scheduled sleep inside/outside its
   interval and with the preference disabled. This is separate from display AOD.
5. Switch AMOLED **Settings → Display Mode → Always-On / High Power** both ways.
   On MIP, **Settings → Sleep Mode** should retain Index's full dial.
6. Run **File → View Screen Heat Map → Start** for the full 24 hours. Record
   completion and peak metric. SDK 9.3 reports luminance usage on tested modern
   targets; this is not a lit-pixel count or proof for other device generations.
7. Save awake, AOD and settings PNGs through **File → Save Screen Capture** under
   ignored `build/`.

## Recover from simulator/UI failures

- Use CLI tools for builds, exports and tests; use UI control for simulator-only
  settings/captures when authorized. If the Mac is locked or access is blocked,
  continue CLI work and report the visual checks left unverified.
- After a timeout, inspect any saved PNG's timestamp, dimensions and image before
  retrying or restarting: the action may have succeeded.
- If Save stays disabled, use Cmd-Shift-G to select a fresh writable directory
  (`/tmp` worked), save there, then copy the file to its destination.
- If capture hangs the simulator, confirm any saved image and restart only that
  simulator process. Preserve application data and global macOS settings.
- Read current UI state after transitions. Prefer small observations; repeated
  full accessibility trees did not resolve the disabled Save issue.
- If the diagnostic window lacks close controls, **Window → CIQ Simulator …**
  returns to the main window.
- Use the [Store fixtures](store-listings.md#prepare-or-revise-images) for repeatable
  listing captures. Before handing back for manual testing, restore a normal
  production app and report its device/name.

## Coverage policy

| Face | Representative displays |
| --- | --- |
| Glyphs | Venu 3 (large round AMOLED), Venu 2S (small round), Venu Sq 2 (rectangle), first-generation Venu (older protection rules) |
| Index | vivoactive_hr (small rectangle/API 2.4), fr735xt (clipped round/API 2.4), fenix5s/fr55 (small MIP), fenix7 (MIP), venusq (LCD), venusq2/venux1 (rectangular AMOLED), venu/venu3 (round AMOLED), instinct3amoled45mm/instinct3amoled50mm (virtual subscreen) |

Glyphs remains AMOLED-only. Index's runtime sample is not its release target list;
physical cutout/hybrid exclusions are documented in its README. Follow the
[device support policy](../README.md#device-support-policy).

After Index catalog/profile changes, run `python3 scripts/check-index-devices`.
It audits API-eligible installed watches, support decisions and display profiles.
Resolve new entries through validation or a documented exclusion.

`export` builds every manifest target. SDK device/API variants may produce more
builds than manifest product IDs; export does not upload the package.

## Evidence and open checks

Report compilation, native assertions, visual checks, heat-map diagnostics and
physical-watch testing separately. Count repeated tests as executions, not new
cases. Renderer changes require settings callbacks, awake/low-power transitions
and representative displays. Inspect thin diagonals at native resolution and guard
newer anti-aliasing calls with `dc has :setAntiAlias`.

- Index's [MIP Sleep Mode marker omission](../mini-index/README.md#known-limitation)
  remains unresolved. A complete frame, reframing or passing geometry test is
  insufficient evidence of a fix.
- A complete Glyphs scheduled-sleep/settings matrix and first-generation Venu
  24-hour heat-map run remain outstanding; other targets do not replace them.
- Simulator results do not measure physical battery use or guarantee display
  longevity. Visibility, power use and firmware differences need hardware checks.

## Sources

- [Garmin unit testing](https://developer.garmin.com/connect-iq/core-topics/unit-testing/)
- [Watch-face guidance](https://developer.garmin.com/connect-iq/articles/user-experience-guidelines/Watch_Faces.html)
- [Device burn-in flag](https://developer.garmin.com/connect-iq/api-docs/Toybox/System/DeviceSettings.html#requiresBurnInProtection-var)
- Installed SDK 9.3 `monkeydo` parser, simulator menus and observed diagnostics.
- [Settings-schema lookup report](https://forums.garmin.com/developer/connect-iq/i/bug-reports/bug-unable-to-detect-settings-file-for-watchface-app-on-linux?CommentId=a6506f01-9f35-4986-88ac-6b8164e75da9)
