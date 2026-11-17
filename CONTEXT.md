# Font Garden Template

Font Garden Template is the start of a new typeface. Replace this paragraph
with the description of the font: what it is, who draws it, the scripts and
the license.

This file is the description of the design. It has three readers:

- A person reads it to understand the typeface: the idea, the construction
  and the decisions. Text about the design in the README, a specimen or an
  article comes from this file.
- An agent reads all of it before it draws or reviews a glyph. Runebender
  gives it to its agents.
- `fgtools` reads the values in the `toml` code blocks. A block holds the
  values of the rule above it, and the tools read all blocks as one TOML
  document.

A design value or a design rule is stated here and in no other file. Font
metrics are in the `fontinfo.plist` files. They are not repeated here.

## Contents

`make test` fails when this table and the chapters differ.

| Chapter | Content |
| --- | --- |
| [The idea](#the-idea) | Why the font exists, and what came before it. |
| [How to use the rules](#how-to-use-the-rules) | How an agent draws and reviews with the numbered rules. |
| [Grid](#grid) | The em and the grids of the points. |
| [Strokes](#strokes) | The stroke weights of each master. |
| [Weights](#weights) | The weights that are drafted from the masters. |
| [Accented letters](#accented-letters) | The positions of marks on base letters. |
| [Project settings](#project-settings) | Settings of the tools: mark colors, reference fonts and known QA debt. |

## The idea

Write the idea of the design here, in prose: the purpose of the font, the
precedents, and the principles that every glyph follows. An agent that
writes a specimen or a README takes its text from this chapter.

## How to use the rules

The rules have numbers (R1, R2 and so on). A number never changes.

- Before you draw or change a glyph, read every rule.
- When you review a glyph, check it against every rule that applies, by
  number. Then look at the whole glyph for faults that no rule names.
- When the designer corrects a glyph and the reason is a principle, add a
  rule with "Seen in" and the commit, or add the commit to the rule that
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

R3. `fgtools draft-weights --build` drafts more weights from two masters, when the
project has a designspace with two masters. `vertical_stem` and
`horizontal_stroke` give the stroke of H in each master and the target of
the weight. The drafts go to `output/weights/`. To use it, remove the comment
signs from the table.

```toml
# [weights.Thin]
# wght = 100
# between = ["Regular", "Bold"]
# vertical_stem = { Regular = 100, Bold = 192, target = 28 }
# horizontal_stroke = { Regular = 88, Bold = 168, target = 26 }
```

## Accented letters

R4. A mark has one height over all letters of one height. Over an ascender
(h, k, l, b, d) and over a capital letter, the mark is above the letter: a
mark at the x-height that cuts into an ascender is a fault. The i and the j
have no dot under a top mark.

R5. A symmetric mark (dieresis, macron, circumflex, caron, breve, ring,
tilde, dot) is on the optical center of the letter. On a symmetric letter
that is the center of its width. An acute or a grave points at the center
with its lower end, so its bounding box is to the right (acute) or to the
left (grave) of the center. On a letter that is not symmetric (L, h, k, r, t,
f, J), the mark is over the stem or over the width: this is a decision of
the design, and all letters of the font follow one decision.

R6. A cedilla joins the bottom of the bowl of C and S at its center. An
ogonek joins the letter at the bottom right (A, a, E, e, U, u) or at the stem
(I, i), without a gap. A comma accent is under the center with a clear gap.
The caron of d, t, l and L is an apostrophe form at the right of the letter.
The comma accent of g is a turned comma over the letter.

R7. A mark does not touch a part of the letter that it is not designed to
join, and the letter does not cut it. The masters have the same components
and the same relative position of the mark.

## Project settings

These tables are settings of the tools, not design rules.

### Mark colors

The mark color of a glyph is its review state. `rgba` lists every value that
the sources use for the color. The policy is what an agent can do with a
glyph that has the color.

```toml
[colors.green]
rgba = [[0, 1, 0, 1], [0.09, 0.72, 0.44, 1]]
policy = """Locked in as close to final. The designer approves contour glyphs. A composite is green when its \
parts are green and `fgtools check-design --ready` lists it."""

[colors.yellow]
rgba = [[1, 1, 0, 1], [1, 0.86, 0.2, 1], [0.91, 0.79, 0.27, 1]]
policy = "Close. Edit without replacing the drawing. Not a reference."

[colors.orange]
rgba = [[1, 0.5, 0, 1], [1, 0.6, 0.06, 1], [0.97, 0.58, 0, 1]]
policy = "Better, not good enough. Edit and keep useful construction. Replace only when the designer says so."

[colors.red]
rgba = [[1, 0, 0, 1], [1, 0.29, 0.24, 1], [1, 0.3, 0.3, 1]]
policy = "Broken. Can be replaced when the designer names the glyph. Not a reference."

[colors.purple]
rgba = [[0.54, 0.44, 0.88, 1], [0.5, 0, 1, 1]]
policy = "AI drawing that the designer has not reviewed. Not a reference."

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
