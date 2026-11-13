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
| QA | `make qa-full` (full Fontspector profile), `make qa-package PACKAGE=<directory>` |
| About text | `documentation/article/ARTICLE.en_us.html`, to be written |
| AI use | Disclose it in the README and the article. The designer approves the glyphs. |

## Open decisions

- Family name: check that it is free to use. A font traced from a specimen
  does not take the name of the original.
- Origin of the design: a font traced from a specimen needs a source that is
  free to use. Record the origin above before the first public release.
- README image: commit an image under `documentation/`.
- Release tag: none yet.

## Before the Add Font issue

1. Every glyph is green in every master (`make status`).
2. `make qa-full` reports no FAIL that applies to this repository.
3. The copyright holders have signed the Google CLA.
4. Search the existing issues, then open the Add Font issue from its template.

For an agent, the full procedure is the task contract
[`.agents/tasks/google-fonts-release.md`](../.agents/tasks/google-fonts-release.md).

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
