# Agent files

`AGENTS.md` at the repository root is the guide for every agent. Codex, Claude
Code and OMP read it.

| Directory | Content |
| --- | --- |
| `skills/` | Procedures that an agent loads by name: `build-and-proof`, `font-qa` and `google-fonts-release`. |
| `tasks/` | Task contracts for long or unattended runs: goal, acceptance, constraints, and the report to give at the end. |

`.omp/RULES.md` is a link to `AGENTS.md`. OMP gives rules to its subagents,
but not `AGENTS.md`, so the link gives subagents the same rules.

## Tasks

| Task | Use |
| --- | --- |
| `tasks/specimen-intake.md` | Turn a specimen image into purple drafts in the UFO. |
| `tasks/glyph-drafts.md` | Draft named glyphs from the green glyphs. |
| `tasks/google-fonts-release.md` | Prepare the release checks and the package. |

## Run a task without a person

Use a separate checkout, so that an unattended run cannot change your working
tree:

```sh
git worktree add ../font-project-template-run main
cd ../font-project-template-run
omp -p --wait-async --max-time 60m \
  "Do the task in .agents/tasks/glyph-drafts.md for: acute caron circumflex, Regular."
```

Then review the branch and its report. `make check-changes` checks the source
changes of any run, and `make diff` shows what changed in the built fonts.
