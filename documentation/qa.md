# Build and QA

Run the commands from the repository root. The tools are in
[fontgarden-tools](https://github.com/fontgarden/fontgarden-tools); its
command is `.venv/bin/fgtools`.

## Setup

`make setup` creates `.venv`, installs the pinned `requirements.txt`, and
runs `fgtools install-tools`, which installs the pinned fontc and Fontspector
binaries into `.venv/bin`. `requirements.in` lists the direct dependencies;
keep the two files in sync when you update the tools.

The design checks need the Runebender binary; set `RUNEBENDER` if it is not
on `PATH`. The specimen intake needs `img2glyph`, `img2bez` and `img2ufo`
(see [`.agents/tasks/specimen-intake.md`](../.agents/tasks/specimen-intake.md)).

## Build

`make build` runs `fgtools build`: it copies the sources to a temporary
directory and builds the fonts with `gftools builder` and fontc, as
`sources/config.yaml` describes. A plain `gftools builder sources/config.yaml`,
as the Google Fonts packager runs it, builds the same fonts with fontmake.

## Commands

| Command | Purpose |
| --- | --- |
| `make build` | Build the fonts into `fonts/`. |
| `make diff` | Build main and the working tree and compare them with diffenator3. `BASE=<revision>` compares with another revision. |
| `make qa` | Fontspector with the Font.Garden profile, offline, without the checks in `[qa.exclude]` of `sources/design.toml`. |
| `make qa-full` | All checks, with network checks. |
| `make qa-package PACKAGE=<directory>` | All checks on an assembled google/fonts package. |
| `make test` | Repository layout and documentation reference tests. |
| `make status` | Rewrite `STATUS.md` from the mark colors. |
| `make check-design GLYPHS="..."` | Compare glyphs with the targets in `sources/design.toml`. |
| `make check-accents` | List the accented letters whose mark is not where the other accented letters predict, or not where the anchors of its parts are. |
| `make accent-proofs` | Draw each accented letter beside the reference fonts and measure it against them. Sheets and `review.json` go to `out/accent-proofs/`. |
| `make check-changes` | Check source changes since `main`: green glyphs unchanged, drafts purple. |
| `make lint` | Structural and curve checks of the sources. |
| `make proof-web` | Compare the current build with `reference-fonts/` in a browser. |

The Font.Garden profile includes the Google Fonts profile and adds: a
1024-unit em, masters on the 2-unit grid, the vendor ID FTGD and the OFL 1.1.
QA writes JSON and Markdown reports to `out/qa/<mode>/`. A FAIL returns a
failing exit status. A WARN needs review. The
[Google Fonts QA guide](https://googlefonts.github.io/gf-guide/qa.html)
explains the severities.

## After a source edit

1. Run `make check-changes` and `make check-design GLYPHS="..."` for the
   edited glyphs.
2. Run `make build`.
3. Run `make diff`. Every changed glyph, word, table or language result must
   be one that the edit explains. The HTML reports are in `out/diff/`.
4. Look at the rendered glyphs in words, at reading and display sizes, beside
   the reference fonts (`make proof-web` or Runebender).

Command success is not visual review. The designer gives the verdict on
drawings.

## Proof rules

- Use the same em size, origin and baseline for every font in a comparison.
- A proof is valid only for the sources it was built from. Do not reuse an
  older proof after an edit.
- `out/` is ignored by Git. Its files do not exist in a new clone.
