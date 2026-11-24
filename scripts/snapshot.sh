#!/usr/bin/env bash
# Compares "what is installed on this computer" with "what the repository records".
# Never rewrites the Brewfiles itself (they hold comments and grouping) - it reports drift.
#   scripts/snapshot.sh            # report
#   scripts/snapshot.sh --vscode   # also refresh vscode/extensions.txt
set -euo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
load_brew || die "brew not found"
cd "$DOTFILES"

step "Installed brew formulae missing from the Brewfile"
comm -13 <(brew bundle list --formula --file=Brewfile | sort) <(brew leaves | sed 's|.*/||' | sort) | sed 's/^/  + /' || true

step "Installed casks missing from Brewfile and Brewfile.apps"
comm -13 <( { brew bundle list --cask --file=Brewfile; brew bundle list --cask --file=Brewfile.apps; } | sort -u ) \
         <(brew list --cask | sort) | sed 's/^/  + /' || true

step "In the Brewfile but not installed here"
brew bundle check --file=Brewfile --verbose 2>&1 | grep '^→' | sed 's/^/  /' || info "everything is installed"

if [ "${1:-}" = "--vscode" ]; then
  step "VS Code extensions"
  have code || die "the code command is not available"
  code --list-extensions | sort > vscode/extensions.txt
  ok "vscode/extensions.txt: $(wc -l < vscode/extensions.txt | tr -d ' ') extensions"
fi
