# Glyphs and Index design notes

## Separate applications

Mini Glyphs and Mini Index have independent application IDs, settings and display
policies. Glyphs uses a word grid designed for AMOLED screens. Index uses analog
hands and supports multiple display technologies. Shared-looking class names are
not shared implementations.

## Glyphs contrast and low power

Background brightness scales the unhighlighted letters independently of the time
words. This preserves custom colors while allowing the grid to be subdued or hidden.
Scheduled sleep follows profile sleep/wake times and hides the background letters.
It is independent of device low power: always-on mode uses a compact neutral-gray
phrase rather than the full grid.

The ambient phrase alternates between separated upper and lower bands each minute.
This extinguishes the previous position's pixels instead of relying on a small
shift of mostly overlapping text. Time remains rounded to the nearest five minutes.
See [Glyphs behavior](../../mini-glyphs/README.md) for settings and boundaries.

## Index display profiles

MIP retains the full dial in low power. AMOLED/LCD uses a smaller gray dial with
alternating positions, hides the date and limits enabled hour markers to four.
Monochrome displays use white hands; devices with a separate upper-right sub-display
use a smaller dial offset down and left to clear that region.

Native anti-aliasing improves thin diagonal hands on supported awake AMOLED/LCD
displays. The API availability guard preserves support for older devices. Date text
is drawn before the hands so the time stays visible when they overlap.

Compatibility follows the installed device catalog and minimum API requirement;
representative test devices are not a release support limit. See
[Index compatibility](../../mini-index/README.md) for exclusions and the catalog audit.

## Verification scope and known limitations

Native tests cover time rounding, scheduled-sleep boundaries, word retention,
ambient text separation, hand angles, dial containment and sub-display clearance.
Visual checks also need to cover settings callbacks and awake/low-power transitions;
geometry assertions cannot establish complete rendered appearance.

Some Mini Index simulator views omit static marker pixels after toggling MIP Sleep
Mode, while other frames are complete. The cause is unresolved and has not been
isolated to capture behavior or device rendering. Reproduction and physical-watch
verification are needed before classifying it as fixed.

A complete manual Glyphs scheduled-sleep/settings matrix and first-generation
Venu 24-hour heat-map run remain outstanding. Simulator heat-map results on other
targets do not establish physical-watch battery consumption or panel longevity.

Use [verification](../verification.md) for reproducible checks and simulator recovery,
and [Store workflow](../store-listings.md) for capture, packaging and export privacy.
Detailed run logs and intermediate captures belong in ignored `build/`.
