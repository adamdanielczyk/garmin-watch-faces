# Mini Studies

Exploratory numeric, word and analog layouts for comparing typography, hierarchy
and optional date placement. These sketches are separate from the published
watch faces and have their own application ID. Use the production `mini-*`
projects for releases.

## Compare the designs

Open [preview.html](preview.html) directly, or run this from the repo root:

```sh
python3 -m http.server 8765 --directory prototypes/mini-studies
```

Then visit `http://localhost:8765/preview.html?variant=chrono`. Variants are `chrono`, `lingua`, and `index`. Use the floating arrows or keyboard arrows. Change time, 12/24-hour mode, date visibility, accent, reference canvas size, and sparse sleep mode. State appears below the controls. No network requests or dependencies.

| Study | Direction | What to judge |
| --- | --- | --- |
| Chrono Quiet | Evolve Chrono with a disciplined default: stacked digits, one accent, optional day | Is the two-line time faster to read than the current horizontal option? |
| Lingua Air | A phrase face combining Lingua's typography with Glyphs' five-minute vocabulary | Is reading remainder dots too much effort? At 10:08, five past ten + three dots = 10:08. At 10:58, five to eleven + three dots = 10:58. |
| Mini Index | New analog family member with four indices and no seconds hand | Does the analog time remain readable without a full minute scale? Does the date distract or collide visually with hands? |

Browser fonts are approximations, not the existing custom font assets or native Garmin metrics. The date is the fixed sample day 10. Size selection changes reference dimensions, not display technology. It cannot validate MIP color quantization or native clipping.

## Native Monkey C experiment

The same three directions are implemented in `source/MiniStudies.mc`, using system fonts and relative coordinates. Prototype settings choose a study, toggle the real day of month, and force a sparse sleep preview. Accent is fixed. Word mode is English-only and uses 12-hour phrases; numeric time respects device clock format.

```sh
python3 prototypes/ciq-study build prototypes/mini-studies venu3
python3 prototypes/ciq-study build prototypes/mini-studies venu3s
python3 prototypes/ciq-study build prototypes/mini-studies fenix7
# Run in the simulator:
./scripts/ciq simulator
python3 prototypes/ciq-study run prototypes/mini-studies venu3
```

Use simulator app settings to choose `Study` and `Preview sparse sleep layout`. The wrapper reuses the repository's SDK/key discovery and keeps generated artifacts under ignored `build/`. It does not expand the production CLI's face list.

The manifest is a **validation target list**, not a claim of compatibility: Venu 3 (454 px AMOLED), Venu 3S (390 px AMOLED), fēnix 7 (260 px MIP). The experiment currently switches every device to sparse digital time on low power, including MIP. A production implementation should retain a suitable full MIP layout and explicitly design AMOLED AOD. Three-pixel movement alone is not demonstrated burn-in protection; the sparse layout is not certified against AOD rules. Native text widths, long phrases and small-screen font heights still need simulator review.

## Design and validation notes

Keep time dominant, with a black background, one accent and at most one optional
secondary field. Lingua Air's remainder dots trade immediate precision for a
shorter phrase; they need readability testing before use in a published face.

Before reusing a study, compile all three targets and inspect wide times, long
phrases, 12/24-hour settings and awake/sleep transitions. Native layout, AOD
compliance and hardware battery use remain unverified for these prototypes.
Preserve language coverage when adapting a published word face.

[Research and official sources](../../docs/research/minimalist-options-2026-11-10.md)
