# Native verification workflow

Use the installed Garmin SDK and simulator. Browser previews cannot validate native font metrics, settings callbacks, screen protection, memory usage or display profiles.

## Build and regression tests

```sh
./scripts/ciq doctor
./scripts/ciq simulator
./scripts/ciq test mini-glyphs venu3
./scripts/ciq test mini-index venu3
./scripts/ciq test mini-index fenix7
./scripts/ciq run mini-index venu3
```

`test` adds Garmin's `--unit-test`, runs `monkeydo -t`, saves stdout/stderr to `build/<face>/<device>/tests/<device>-tests.log`, and requires an explicit non-empty passing summary. SDK 9.3's test runner can return process status 1 despite all tests passing; the helper checks the test summary instead. A timeout replaces the log with a failure marker. Run simulator tests sequentially, since they share one simulator.

Executables now use a stable per-app basename in `build/<face>/<device>/<face>.prg`. Device variants are in separate directories. This prevents different faces from sharing an executable/settings filename, and avoids changing the app's filename when switching devices. Test programs live in a separate `tests/` directory but retain the same basename, so running tests first does not create a second settings-schema lookup name.

`run` transfers the generated app-settings JSON using the SDK's documented `monkeydo -a` option. Without it, the simulator's settings editor reports that no settings file exists. The settings editor needs access to Garmin's hosted settings UI; it may finish loading shortly after the dialog opens.

### Existing simulator metadata after renaming executables

The simulator can retain the first executable name registered for a manifest ID even after later app loads and simulator restarts. If an app was first loaded under a generic name such as `VENU3.PRG`, supply its current schema under that original name:

```sh
./scripts/ciq run mini-glyphs venu3 --settings-alias VENU3
```

The alias option directly refreshes that one JSON file in the simulator temporary directory: SDK 9.3 cached the old alias when the same schema was sent twice with `-a`. Use only the known original executable stem for that app. This is an explicit migration workaround, not automatic settings deletion. If unrelated apps have collided under an older filename, avoid editing them simultaneously. New sessions using stable face names do not introduce that collision. Do not reset all simulator apps merely to fix one app's settings.

## Visual checklist

1. Run the face for each representative display. Confirm the title names the intended device and wait for the loaded face, not an empty simulator window.
2. Use **Simulation → Time Simulation** for deterministic times. Test 00:00, 11:58, 10:32, 10:33 and 10:25 for Glyphs; test 12:00, 03:15, 06:30 and 10:08 for Index. A faster simulation factor helps check minute transitions. Stop time simulation afterwards if a normal live clock is wanted.
3. Use **File → Edit Persistent Storage → Edit Application.Properties data** to change settings. Check the right app in the selector, save, wait for the **Settings Saved** confirmation, acknowledge it, then close the editor and inspect the redraw. Closing immediately after Save can leave old values active. Glyphs: background 0/60/100, custom/preset colors, scheduled-sleep preference. Index: none/four/twelve markers, date, preset/custom RGB accent. In AMOLED always-on, None stays empty and Four/Twelve use four markers.
4. Use **Settings → Set User Profile** to check the scheduled-sleep layout separately from display mode. Test inside/outside its interval and disabling the preference. AOD is independent of this profile schedule.
5. Use **Settings → Display Mode → Always-On / High Power** on AMOLED. Check both directions. On MIP, **Settings → Sleep Mode** should leave Index's full dial visible.
6. Use **File → View Screen Heat Map → Start** for Garmin's full 24-hour burn-in simulation. Record the completion message and peak metric. SDK 9.3 reports luminance usage for the tested modern targets. Do not equate it to the number of lit pixels, or assume identical rules across all device generations.
7. Save face-only PNGs with **File → Save Screen Capture** into ignored `build/`. Capture awake, AOD and representative settings. A locked Mac blocks UI actions/screenshots, even when CLI builds continue.

The simulator's diagnostic window may replace its titlebar close controls with macOS's window-sharing indicator. **Window → CIQ Simulator …** returns to the main window without quitting the app.

## Recover from simulator/UI failures

Use CLI tools for discovery, builds, exports and native tests. Use UI control for
simulator-only settings, mode changes and native screen capture when authorized.
Respect the user's current computer-use restriction. If access is blocked or the
Mac is locked, continue independent CLI work and report exactly which visual checks
remain; repeated UI retries cannot establish a visual pass.

- A UI timeout may happen after the action succeeded. Check the saved PNG's path,
  modification time, dimensions and image before retrying Save or restarting.
- If Save stays disabled, navigate to a different writable folder with Cmd-Shift-G
  (a fresh directory under `/tmp` worked), then save there and copy the PNG into
  the intended evidence directory. Setting the name alone did not always enable Save.
- If native capture leaves the simulator unresponsive, identify its exact current
  process and restart only that process. Confirm the capture first. Avoid resetting
  application data or changing global macOS settings to recover a screenshot.
- Re-read the current UI state after each transition. Collapse the file browser when
  possible; repeated full accessibility trees were noisy and did not resolve a
  disabled Save button. Prefer the smallest observation that answers the next step.
- For repeatable listing captures, use the isolated fixed-input fixture documented
  in [Store workflow](store-listings.md), rather than repeatedly pausing live time
  simulation and racing to save. Restore a normal production app when handing the
  simulator back for manual testing, and state which device/app is loaded.

## Record evidence and unresolved defects

Separate compilation, native assertions, visual checks, heat-map diagnostics and
physical-watch testing in reports. Count repeated tests as executions, not new cases.
Exercise settings callbacks, awake/low-power transitions and representative screen
sizes/display technologies after renderer changes. Inspect thin diagonals at native
resolution; use `dc has :setAntiAlias` before APIs unavailable on older targets.

Mini Index's intermittent missing static marker pixels after MIP Sleep Mode remain
unresolved (see [known limitations](implementation/glyphs-and-index.md)). Complete
frames were also observed. Neither successful compilation, geometry tests, a later
complete frame nor screenshot reframing proves this defect fixed. Track it until a
repeatable simulator/device check resolves the cause.

## Coverage policy

Glyphs: large round AMOLED (Venu 3), small round AMOLED (Venu 2S), rectangular AMOLED (Venu Sq 2), and first-generation Venu for older protection rules. Keep the existing AMOLED-only manifest intact.

Index: run `python3 scripts/check-index-devices` to audit all compatible installed watch products and their display profiles. Representative runtime targets: vivoactive_hr (small rectangle/API 2.4), fr735xt (clipped round/API 2.4), fenix5s/fr55 (small MIP), fenix7 (MIP), venusq (LCD), venusq2/venux1 (rectangular AMOLED), venu/venu3 (round AMOLED), instinct2s/instincte40mm (monochrome cutout), instinctcrossover (monochrome hybrid). Keep broad manifest support; the runtime sample is not the release target list.

`export` builds local packages for every manifest target; SDK device/API variants may make its reported build count exceed the number of manifest product IDs. Export does not upload anything.

## Limits

Simulator success is not a physical battery measurement or a guarantee of long-term display longevity. Real-watch visibility, power consumption, and vendor firmware differences remain hardware acceptance checks. Do not claim that sparse output alone establishes battery-life improvements.

## Sources

- [Garmin unit testing](https://developer.garmin.com/connect-iq/core-topics/unit-testing/)
- [Garmin watch-face guidance](https://developer.garmin.com/connect-iq/articles/user-experience-guidelines/Watch_Faces.html)
- [Garmin device burn-in flag](https://developer.garmin.com/connect-iq/api-docs/Toybox/System/DeviceSettings.html#requiresBurnInProtection-var)
- Installed SDK 9.3 `bin/monkeydo` usage/parser; native simulator menus and observed diagnostics.
- [Garmin forum report on settings-schema lookup](https://forums.garmin.com/developer/connect-iq/i/bug-reports/bug-unable-to-detect-settings-file-for-watchface-app-on-linux?CommentId=a6506f01-9f35-4986-88ac-6b8164e75da9)
