# Font Garden Template

Font Garden Template is the starting point of a Font.Garden font project: a
font source repository in the Google Fonts layout, with the Font.Garden tools,
QA and agent instructions. It holds a starter font with two glyphs.

## Start a font

1. Create a repository from this template ("Use this template" on GitHub).
2. Install the tools and name the family:

   ```sh
   make setup
   make customize FAMILY="My Face" DESIGNER="Your Name" EMAIL=you@example.com
   ```

   `customize` renames the family in the sources, the documents and the file
   names. Then replace this section with a description of the font.
3. Add glyphs. Draw them in the UFO, or turn a specimen image into drafts
   with the task in
   [.agents/tasks/specimen-intake.md](.agents/tasks/specimen-intake.md).

## Commands

| Command | Use |
| --- | --- |
| `make setup` | Create `.venv` and install the requirements and the pinned tools. |
| `make build` | Build the fonts into `fonts/` with fontc. |
| `make qa` | Check the fonts with the Font.Garden Fontspector profile. |
| `make diff` | Compare builds of `main` and the working tree with diffenator3. |
| `make proof-web` | Build, then compare the font with the fonts in `reference-fonts/` in a browser. |
| `make status` | Rewrite [STATUS.md](STATUS.md) from the mark colors. |
| `make test` | Check the repository layout and the document references. |

`make help` lists all commands. [documentation/qa.md](documentation/qa.md)
describes the build and the checks.

## Method

The em is 1024 units and every point is on a 2-unit grid. Each glyph has a
mark color that gives its state: purple is a draft that the designer has not
reviewed, red, orange and yellow are grades, and green is approved. The
release target is every glyph green.
[documentation/design/learning.md](documentation/design/learning.md)
describes the loop of drafts, checks, grades and corrections.

## Tools

The tools are shared by all Font.Garden fonts and are in
[fontgarden-tools](https://github.com/fontgarden/fontgarden-tools), with the
command `fgtools`: status, design checks, change checks, the build, QA, build
comparisons, the web proof and the drafting evaluation. `make setup` installs
them, pinned to a commit in `requirements.txt`, with the pinned fontc and
Fontspector binaries.

AI tools help with code, documentation and draft glyphs. The designer draws,
reviews and approves the glyphs. The rules for agents are in
[AGENTS.md](AGENTS.md).

## License

The font is licensed under the [SIL Open Font License, Version 1.1](OFL.txt).
The copyright holders are in [AUTHORS.txt](AUTHORS.txt) and the contributors
in [CONTRIBUTORS.txt](CONTRIBUTORS.txt).
