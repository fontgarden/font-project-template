# Task: turn a specimen image into purple drafts

Start this task with a specimen image from the designer, and the facts that
only the designer can give: the family name, the origin of the specimen, and
that the design is free to use.

## Goal

The UFO in `sources/` holds one traced glyph for each glyph of the specimen,
placed on the baseline at the right scale, marked purple, and ready for the
designer to grade.

## Acceptance

- `sources/specimen/` holds the specimen image and `labels.json`, and
  `documentation/google-fonts.md` states the origin of the specimen.
- Every glyph of the specimen is in the UFO with its Unicode value. Each one
  is purple.
- The vertical metrics in `fontinfo.plist` come from the specimen: cap height,
  x-height, ascender and descender, measured in the image and snapped to the
  8-unit grid. The em is 1024 units.
- No traced glyph has contours from scan dust: a contour smaller than the
  smallest dot of the design is removed.
- `make lint` reports no structural fault. `make build` succeeds.
- `make qa` reports no FAIL outside `[qa.exclude]` of `context.md`.
- `make status` is run, and `make test` passes.

## Method

The tools are `img2glyph`, `img2bez` and `img2ufo`
(https://github.com/fontgarden/img2ufo). Read the agent guide of img2ufo first;
it lists the known faults and their causes.

1. Copy the image to `sources/specimen/` with a plain file name. Check its
   resolution: a glyph of about 500 pixels gives a clean trace, and a glyph
   of about 100 pixels gives an uneven one. Report a low resolution; do not
   enlarge the image to hide it.
2. Segment the image into `out/specimen/glyphs` with `img2glyph process`.
   Look at several crops. A hollow crop means that `--block-radius` is
   smaller than the widest stroke.
3. Label the crops. Write `sources/specimen/labels.json`, one Unicode value
   for each crop. Look at each row of crops to confirm the order.
4. Measure the cap height, x-height, ascender and descender in pixels from
   the manifest. Keep the proportions of the specimen and snap the targets to
   multiples of 8.
5. Run `img2ufo` with the labels and the metrics, with `--output` on the UFO
   in `sources/`, `--worklist out/specimen/completion.json` and `--no-qa`.
   It marks each trace purple, the mark of a draft that the designer has not
   reviewed (`context.md`). A later run replaces only purple and
   red glyphs.
6. Render the font in a line of text and compare it with the specimen. Find
   the glyphs that sit too high or too low, and the contours from dust.
   Correct the placement faults; report the faults of shape.

## Constraints

- Trace only from raster images. Do not copy or convert outlines from a
  digital font file.
- Do not give the font the name of the original typeface.
- Do not correct the shape of a glyph in this task. A traced glyph is a
  draft; the designer grades it, and `glyph-drafts.md` covers redrawing.
- Do not push or publish. The origin of the specimen decides whether the
  font can be published; that decision is the designer's.

## Report

Give the glyph count, the measured and the chosen metrics, the image
resolution, the QA result, and a rendered line of text. List the glyphs with
faults of placement or shape, and the glyphs of the Google Fonts Latin Core
set that are still missing.
