# Minimalist watch face design references

Design notes from November 2026 for the [Mini Studies prototypes](../../prototypes/mini-studies/README.md).
These are exploratory directions, not a description of released features.
Consult each production face's README for its current behavior and device support.

## Design directions

- Numeric time: compare stacked and horizontal layouts with wide digit combinations.
- Word time: prioritize spacing and longest-string fitting; preserve localization.
  Remainder dots can shorten phrases but need readability testing.
- Word grids: distinguish normal display, scheduled sleep and device always-on
  states. Background letters need a separate contrast treatment.
- Analog time: keep hands distinct, make markers optional and check date placement
  against the hands throughout the day.

Shared defaults: time first, a black background, one accent and minimal secondary
information. Additional settings should preserve a simple initial appearance.

## Platform references

Use Garmin's documentation when turning a sketch into a production face:

- [Watch Faces](https://developer.garmin.com/connect-iq/articles/user-experience-guidelines/Watch_Faces.html)
  and [Entry Points](https://developer.garmin.com/connect-iq/articles/user-experience-guidelines/Entry_Points.html):
  always-on layouts, display-specific guidance and burn-in protection.
- [Low- and High-Power Modes](https://forums.garmin.com/developer/connect-iq/b/news-announcements/posts/changes-to-watch-face-low--and-high-power-modes)
  and [App Types](https://developer.garmin.com/connect-iq/articles/connect-iq-basics/App_Types.html):
  update cadence and rendering constraints.
- [Complications API](https://developer.garmin.com/connect-iq/api-docs/Toybox/Complications.html)
  and [Complications guide](https://developer.garmin.com/connect-iq/articles/core-topics/Complications.html):
  optional data fields and their API, permission and device requirements.

Validate against the target device and installed SDK. Browser proportions do not
establish native text fitting, MIP color behavior or AMOLED always-on compliance.
Battery claims require measurements on hardware.
