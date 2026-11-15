-include local.mk

PYTHON ?= ./.venv/bin/python
# The shared Font.Garden tools: https://github.com/fontgarden/fontgarden-tools
FGTOOLS ?= ./.venv/bin/fgtools
# The revision that make diff and make check-changes compare with.
BASE ?= main

.PHONY: help venv setup customize build diff proof-web reference-fonts runebender qa qa-full qa-package test status queue check-design check-accents accent-proofs check-changes corrections lint clean

help:
	@printf '%s\n' \
		'Start:' \
		'  make setup          Create .venv and install the requirements and the pinned tools' \
		'  make customize FAMILY="My Face" DESIGNER="Name" EMAIL=me@example.com' \
		'                      Rename the template to a new family (once)' \
		'' \
		'Design work:' \
		'  make status         Rewrite STATUS.md from the mark colors' \
		'  make queue          Rank the glyphs that most composites wait on' \
		'  make check-design GLYPHS="n a"  Check glyphs against sources/design.toml' \
		'  make check-accents  List the accented letters whose mark is not where the others predict' \
		'  make accent-proofs  Draw each accented letter beside the reference fonts, with measurements' \
		'  make check-changes  Check source changes since main (green unchanged, drafts purple)' \
		'  make lint           Structural and curve checks of the sources' \
		'  make corrections    List the corrections of purple drafts that no rule cites' \
		'' \
		'Build and review:' \
		'  make build          Build the fonts into fonts/ with fontc' \
		'  make diff           Compare builds of main and the working tree (diffenator3)' \
		'  make proof-web      Build, then compare with reference-fonts/ in a browser' \
		'  make reference-fonts  Get the reference fonts that sources/design.toml lists' \
		'  make runebender     Open the sources in Runebender' \
		'' \
		'QA:' \
		'  make qa             Font.Garden Fontspector profile, offline, with the listed exclusions' \
		'  make qa-full        All checks, with network checks' \
		'  make qa-package PACKAGE=dir  Check an assembled google/fonts package' \
		'  make test           Repository layout and documentation reference tests'

# gftools packager --their-venv runs `make venv`.
venv: setup

setup:
	python3 -m venv .venv
	$(PYTHON) -m pip install -r requirements.txt
	$(FGTOOLS) install-tools

customize:
	@test -n "$(FAMILY)" || { echo 'Set FAMILY="My Face" DESIGNER="Name" EMAIL=me@example.com' >&2; exit 2; }
	$(FGTOOLS) customize --family "$(FAMILY)" --designer "$(DESIGNER)" --email "$(EMAIL)" $(if $(REPOSITORY),--repository "$(REPOSITORY)",)

build:
	$(FGTOOLS) build

diff:
	$(FGTOOLS) diff --base "$(BASE)"

proof-web: build
	$(FGTOOLS) proof-web --current

# Copies the families of [reference_fonts.families] in sources/design.toml into
# reference-fonts/, which Git ignores. See `fgtools fetch-reference-fonts --help`.
reference-fonts:
	$(FGTOOLS) fetch-reference-fonts --project

# Opens the sources in Runebender. Install it with
# cargo install --locked --git https://github.com/fontgarden/runebender runebender
RUNEBENDER_SOURCE ?= $(firstword $(wildcard sources/*.designspace) $(wildcard sources/*.ufo))
runebender:
	runebender "$(RUNEBENDER_SOURCE)" &

qa: build
	$(FGTOOLS) qa

qa-full: build
	$(FGTOOLS) qa --full

qa-package:
	@test -n "$(PACKAGE)" || { echo "Set PACKAGE=/path/to/ofl/<family>" >&2; exit 2; }
	$(FGTOOLS) qa --package "$(PACKAGE)"

test:
	$(PYTHON) -m unittest discover -s tests

status:
	$(FGTOOLS) status

# Usage: make check-design GLYPHS="n a". Without GLYPHS it reports on every
# glyph that is not green.
check-design:
	$(FGTOOLS) check-design $(if $(GLYPHS),$(GLYPHS),--not-green)

queue:
	$(FGTOOLS) queue

# Lists the accented letters whose mark is not where the other accented
# letters predict, or not where the anchors of its parts are.
check-accents:
	$(FGTOOLS) check-accents

# Sheets and review.json in out/accent-proofs/. The reference fonts are the
# shared collection of FONTGARDEN_REFERENCE_FONTS.
accent-proofs:
	$(FGTOOLS) render-accent-proofs

# Usage: make check-changes BASE=main GLYPHS="a e"
check-changes:
	$(FGTOOLS) check-changes --base "$(BASE)" $(if $(GLYPHS),--glyphs "$(GLYPHS)",)

corrections:
	$(FGTOOLS) corrections $(if $(ALL),--all,)

lint:
	$(FGTOOLS) lint-glifs
	$(FGTOOLS) lint-curves Regular --all

clean:
	rm -rf build build.ninja .ninja_log fonts out sources/build.ninja sources/.ninja_log sources/instance_ufos
