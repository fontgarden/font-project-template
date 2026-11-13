-include local.mk

PYTHON ?= ./.venv/bin/python
# The shared Font.Garden tools: https://github.com/fontgarden/fontgarden-tools
FGTOOLS ?= ./.venv/bin/fgtools
# The revision that make diff and make check-changes compare with.
BASE ?= main

.PHONY: help venv setup customize build diff proof-web runebender qa qa-full qa-package test status queue check-design check-changes corrections lint clean

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
		'  make check-changes  Check source changes since main (green unchanged, drafts purple)' \
		'  make lint           Structural and curve checks of the sources' \
		'  make corrections    List the corrections of purple drafts that no rule cites' \
		'' \
		'Build and review:' \
		'  make build          Build the fonts into fonts/ with fontc' \
		'  make diff           Compare builds of main and the working tree (diffenator3)' \
		'  make proof-web      Build, then compare with reference-fonts/ in a browser' \
		'  make runebender     Open the sources in the Runebender web editor' \
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

# Edits to the sources reload in the browser, and Cmd+S saves back to disk.
runebender:
	runebender-serve sources --open

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
