# Google Fonts release

The Google Fonts requirements change over time. This file holds only the
facts of this project and the open decisions. For each requirement, read the
current official page.

## Project facts

| Item | Value |
| --- | --- |
| Family name | Font Garden Template |
| Upstream repository | https://github.com/fontgarden/font-project-template |
| Scripts in the first release | Latin |
| Styles | Regular |
| Source of the design | State it here: an original design, or the specimen in `sources/specimen/` with its origin and date. |
| License | SIL Open Font License 1.1 (`OFL.txt`) |
| Build | `make build` (`fgtools build` with `sources/config.yaml`) |
| QA | `make test` (every check except `[qa.exclude]` of `CONTEXT.md`), `fgtools qa --package <directory>` |
| About text | `documentation/article/ARTICLE.en_us.html`, to be written |
| AI use | Disclose it in the README and the article. The designer approves the glyphs. |

## Open decisions

- Family name: check that it is free to use. A font traced from a specimen
  does not take the name of the original.
- Origin of the design: a font traced from a specimen needs a source that is
  free to use. Record the origin above before the first public release.
- README image: commit an image under `documentation/`.
- Release tag: none yet.

## Build

`make build` runs `fgtools build`, which builds the fonts with
`gftools builder` and fontc. A plain `gftools builder sources/config.yaml`,
as the Google Fonts packager runs it, builds the same fonts with fontmake.
`fgtools diff --fontmake` checks that fontc and fontmake give the same glyph
and word images.

## QA

| Command | Use |
| --- | --- |
| `make test` | Every check: the repository, the Google Fonts checks, the Font.Garden checks and the checks of this font, without the known faults in `[qa.exclude]` of `CONTEXT.md`. The CI gate. |
| `make test-google-fonts` | The Google Fonts checks only. |
| `make test-fontgarden` | The Font.Garden checks and the checks of this font only. |
| `fgtools qa --package <directory>` | Every check, with no exclusions, on a package with `METADATA.pb`, `OFL.txt` and the article. |

The profile is the Google Fonts profile plus the Font.Garden requirements: a
1024-unit em, masters on the 2-unit grid, the vendor ID FTGD and the OFL 1.1.
The reports are in `output/qa/<checks>/`: `all`, `google-fonts`, `fontgarden` or `package`. Read the JSON report, and count unique
findings, not one finding for each font. A FAIL needs a fix or an exception
that the designer approves. A WARN needs a decision by the designer. Outline warnings are
listed for the designer by glyph name and are not corrected. Do not add exclusions,
remove cmap entries or reduce the script scope to get a cleaner result.

Coverage and table presence do not prove shaping. Look at mark attachment,
joining, right-to-left and mixed text, spacing and the intermediate weights
in a rendered proof.

## Package

1. Work in a directory under `output/`. Copy the reviewed TTFs and `OFL.txt`
   into `ofl/<family>/` and run `gftools add-font` on it.
2. Copy `documentation/article/ARTICLE.en_us.html` and its image to
   `article/`.
3. Check the generated metadata: names, designer, category, axes, subsets,
   primary script, date and source.
4. Run `fgtools qa --package <directory>`.

Read `gftools packager --help` before you use it. Some of its modes commit,
push or open a pull request. Use only a local preview unless the designer authorizes
publication.

## Before the Add Font issue

1. Every glyph is green in every master (`make status`).
2. `make test` passes, and `[qa.exclude]` of `CONTEXT.md` has only
   `googlefonts/repo/dirname_matches_nameid_1`, which applies to the
   google/fonts package directory and not to this repository.
3. The copyright holders have signed the Google CLA.
4. Search the existing issues, then draft the Add Font issue from its
   template. Leave the copyright, CLA and image-license attestations
   unchecked: only the designer can confirm them. The issue comes before a pull
   request.

Do not post, push, tag or publish without the authorization of the designer. Report what
is local, drafted, submitted and published as separate states.

## Official sources

| Subject | Link |
| --- | --- |
| Guide (all chapters) | https://googlefonts.github.io/gf-guide/ |
| Upstream repository structure | https://googlefonts.github.io/gf-guide/upstream.html |
| Onboarding a new font | https://googlefonts.github.io/gf-guide/onboarding.html |
| Font file requirements | https://googlefonts.github.io/gf-guide/requirements.html |
| Variable fonts | https://googlefonts.github.io/gf-guide/variable.html |
| Outline quality | https://googlefonts.github.io/gf-guide/outlines.html |
| Diacritics | https://googlefonts.github.io/gf-guide/diacritics.html |
| QA and Fontspector | https://googlefonts.github.io/gf-guide/qa.html |
| METADATA file | https://googlefonts.github.io/gf-guide/metadata.html |
| Article | https://googlefonts.github.io/gf-guide/article.html |
| Packaging | https://googlefonts.github.io/gf-guide/package.html |
| Making a pull request | https://googlefonts.github.io/gf-guide/making-pr.html |
| Project template | https://github.com/googlefonts/googlefonts-project-template |
| Add Font issue template | https://github.com/google/fonts/blob/main/.github/ISSUE_TEMPLATE/1_add-font.md |
| Google Fonts repository | https://github.com/google/fonts |
| Fontspector | https://github.com/fonttools/fontspector |
| gftools (builder, packager) | https://github.com/googlefonts/gftools |
| Glyph sets | https://github.com/googlefonts/glyphsets |
| Contributor License Agreement | https://cla.developers.google.com/ |
