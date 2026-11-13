# Learning loop

This document defines how design work is checked, and where a correction is
recorded. The aim is to keep what the project learns without adding a file for
each event.

## The loop

1. **Choose.** `make queue` ranks the glyphs that most composites wait on.
   The designer names the glyphs to draw.
2. **Draft.** An agent or a model drafts the glyph as a Runebender proposal,
   or in the source with a purple mark. The draft is committed before the designer
   edits it.
3. **Measure.** `make check-design GLYPHS="..."` compares the draft with the
   targets in [design.toml](../../sources/design.toml). Correct the findings before
   review. A pass is a filter, not approval.
4. **Review.** The designer compares the glyph with the reference fonts in Runebender
   or `make proof-web`, then grades it. The review commit changes the purple
   mark to red (broken), orange (better, not good enough), yellow (close) or
   green (locked in as close to final), with or without a correction. A
   glyph can stay yellow for a long time.
5. **Learn.** `make corrections` lists the open corrections. Each one becomes
   a change to the system, as described below.

## The trace is the Git history

The draft commit and the correction commit are the record of a decision. Do
not copy drafts or corrections into files. To read a trace:

```sh
git log --follow -p -- sources/FontGardenTemplate-Regular.ufo/glyphs/<file>.glif
```

## How a correction changes the system

`make corrections` reads the Git history. It finds each review of a purple
draft and compares the draft with the first green version of the glyph. Until
the glyph is green, it compares the draft with the latest version that is not
purple, for example a yellow one. If that version differs from the draft, the
review is a correction. A
correction is open until a tracked file or a later commit message cites the
hash of its review commit. When the designer asks,
an agent reads each open correction (the diff, renders before and after, and
the designer's commit message) and proposes one of these changes:

| The correction shows | Change | The citation |
| --- | --- | --- |
| a mistake that a script can find | a value in `sources/design.toml` or a check in fontgarden-tools | the commit message |
| a mistake that repeats | a rule entry | "Seen in" in the entry |
| a decision that a drafting method has to learn | a case in `sources/held-out-glyphs.toml` | a comment on the case |
| a fault of one glyph only | one line in a glyph record under `documentation/design/` | the line |

The designer approves or rejects each change. One correction is not a rule. When the
same mistake occurs again, add the glyph and commit to the existing entry.

The summary of `make corrections` gives, for each month, the grades, the
drafts that reached green without change, the drafts that the designer corrected, and
the mean overlap of the drafts with the designer's version. If the system
improves, the grades rise, more drafts are accepted and the overlap
increases. The drafting evaluation measures the same
methods on fixed cases, so its scores can also be compared over time.

A rule entry has this form:

```markdown
### Turns keep one direction of curvature

A convex turn must not reverse its curvature. Read the comb before review.
Seen in: a Regular (a1b2c3d4), s Regular (e5f6a7b8).
```

When a script can test a rule, keep only the reason in the rule document.

A rule document has at most 200 lines; the layout test enforces this. When a
document is full, merge entries or move checkable values into scripts.

## Checks and their limits

`fgtools check-design` uses Runebender for measurement and holds the
Font.Garden policy. The checks find faults; a finding is a prompt to look, not
an error, and a pass is not approval.

Run `fgtools check-design --green` after a change to the targets or the
checks. If fewer green glyphs pass, the change made the checks worse. Stroke
targets exist only where green glyphs exist. Set them with
`fgtools check-design --observe`.

## Drafting evaluation

`fgtools evaluate-drafting` tests a drafting method (an agent, a model or
a script) on green glyphs that it has not seen. The glyphs are in
`sources/held-out-glyphs.toml`, in four tasks:

| Task | The method gets | It must |
| --- | --- | --- |
| redraw | the sources without the glyph | draw the glyph in every master |
| bold | the green Regular, without the Bold | draw the Bold |
| repair | the glyph with some points moved | move the points back |
| relatives | green glyphs of the same construction | draw the glyph from them |

1. `fgtools evaluate-drafting prepare TASK RUN` copies the sources to
   `RUN/sources` and sets the task. `fgtools evaluate-drafting run` also runs
   an agent harness in the copy.
2. The method edits only `RUN/sources`. A method that reads `sources/` or the
   Git history has seen the references, so its score is not valid.
3. `fgtools evaluate-drafting score RUN` scores the overlap and distance from
   the designer's drawing, the master compatibility, the grid and the project
   checks.
4. `fgtools evaluate-drafting table RUN ...` compares runs.

## Grades

The designer approves contour glyphs. A composite is green when its parts are green
and `fgtools check-design --ready` lists it. An agent can mark such a composite
green. Model scores and evaluation scores do not approve a glyph.

Training data comes from green glyphs only. Keep the glyphs of one
construction family, and the two masters of one glyph, on the same side of a
training and evaluation division.
