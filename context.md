# Font Garden Template design rules

The rules of this font for every drawing, draft and review, and the values
that the tools check. This is the one design file of the project. Runebender
gives it to its agents, and the task contracts in `.agents/` require it.

A `toml` code block holds the values of the rule above it. `fgtools` reads
only these blocks, as one TOML document. Font metrics are in the
`fontinfo.plist` files; they are not repeated here.

How to use it:

- Before you draw or change a glyph, read every rule here.
- When you review a glyph, check it against every rule that applies, by
  number. Then look at the whole glyph for faults that no rule names.
- When the designer corrects a glyph and the reason is a principle, add a
  rule here with "Seen in" and the commit, or add the commit to the rule that
  covers it.

## Grid

R1. The em is 1024 units. Every point is on the 2-unit grid. Structural
points are on the 8-unit grid. A point on the 2-unit grid and off the 8-unit
grid is an optical correction: keep it.

```toml
[grid]
source = 2         # every point is on the 2-unit grid
machine_draft = 8  # new drafts use the 8-unit grid
```

## Strokes

R2. The stroke thickness of each master and script is in a range. Set the
ranges from the green glyphs with `fgtools check-design --observe` when the
first glyphs are green. A measured span longer than `stroke_limit` is not a
stroke.

```toml
[targets]
```

## Weights

R3. `make draft-weights` drafts more weights from two masters, when the
project has a designspace with two masters. `vertical_stem` and
`horizontal_stroke` give the stroke of H in each master and the target of
the weight. The drafts go to `out/weights/`. To use it, remove the comment
signs from the table.

```toml
# [weights.Thin]
# wght = 100
# between = ["Regular", "Bold"]
# vertical_stem = { Regular = 100, Bold = 192, target = 28 }
# horizontal_stroke = { Regular = 88, Bold = 168, target = 26 }
```

## Project settings

These tables are settings of the tools, not design rules.

### Mark colors

The mark color of a glyph is its review state. `rgba` lists every value that
the sources use for the color. The policy is what an agent can do with a
glyph that has the color.

```toml
[colors.green]
rgba = [[0, 1, 0, 1], [0.09, 0.72, 0.44, 1]]
policy = """Locked in as close to final. Eli approves contour glyphs. A composite is green when its \
parts are green and `fgtools check-design --ready` lists it."""

[colors.yellow]
rgba = [[1, 1, 0, 1], [1, 0.86, 0.2, 1], [0.91, 0.79, 0.27, 1]]
policy = "Close. Edit without replacing the drawing. Not a reference."

[colors.orange]
rgba = [[1, 0.5, 0, 1], [1, 0.6, 0.06, 1], [0.97, 0.58, 0, 1]]
policy = "Better, not good enough. Edit and keep useful construction. Replace only when Eli says so."

[colors.red]
rgba = [[1, 0, 0, 1], [1, 0.29, 0.24, 1], [1, 0.3, 0.3, 1]]
policy = "Broken. Can be replaced when Eli names the glyph. Not a reference."

[colors.purple]
rgba = [[0.54, 0.44, 0.88, 1], [0.5, 0, 1, 1]]
policy = "AI drawing that Eli has not reviewed. Not a reference."

[colors.blue]
rgba = [[0.27, 0.44, 1, 1]]
policy = "Composite that needs diagnosis. Not a reference."

[colors.pink]
rgba = []  # no glyph uses pink now
policy = "Composite that needs small edits. Not a reference."
```

### Reference fonts

The fonts that the proofs and Runebender show beside this font. They are for
comparison of weight, spacing and structure. They are not a source of
outlines. Each key is a directory name of https://github.com/google/fonts
under `ofl/`, and each value is the reason that the family is a reference.
`make reference-fonts` copies the families into `reference-fonts/`, which Git
ignores.

```toml
[reference_fonts.families]
inter = "A neutral sans for text and interfaces, with wide language coverage."
sourcesans3 = "A sans for text from a professional foundry, with even spacing."
```

### Known QA debt

Known development debt, not release exceptions. `fgtools qa` leaves these
checks out, and `fgtools qa --full` runs them. Remove a check when the font
passes it. Do not add a check to hide a new failure.

```toml
[qa.exclude]
"googlefonts/glyph_coverage" = "The glyph set is not complete."
"googlefonts/glyphsets/shape_languages" = "The glyph set is not complete."
"googlefonts/render_own_name" = "The glyph set is not complete."
"opentype/monospace" = "The starter font has only spaces, so every advance is the same."
"family/win_ascent_and_descent" = "The starter font has no glyph below the baseline."
"googlefonts/repo/dirname_matches_nameid_1" = "Needs the google/fonts package directory."
```
