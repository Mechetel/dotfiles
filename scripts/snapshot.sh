#!/usr/bin/env bash
# Сверка «что стоит на этом компьютере» и «что записано в репозитории».
# Ничего не меняет в Brewfile сам (там комментарии и разбивка) — показывает расхождения.
#   scripts/snapshot.sh            # отчёт
#   scripts/snapshot.sh --vscode   # ещё и обновить vscode/extensions.txt
set -euo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
load_brew || die "brew не найден"
cd "$DOTFILES"

# leaves минус то, что уже в Brewfile
step "brew-формулы, которые стоят, но не записаны в Brewfile"
comm -13 <(brew bundle list --formula --file=Brewfile | sort) <(brew leaves | sed 's|.*/||' | sort) | sed 's/^/  + /' || true

step "casks, которые стоят, но не записаны ни в Brewfile, ни в Brewfile.apps"
comm -13 <( { brew bundle list --cask --file=Brewfile; brew bundle list --cask --file=Brewfile.apps; } | sort -u ) \
         <(brew list --cask | sort) | sed 's/^/  + /' || true

step "записано в Brewfile, но не стоит здесь"
brew bundle check --file=Brewfile --verbose 2>&1 | grep '^→' | sed 's/^/  /' || info "всё стоит"

if [ "${1:-}" = "--vscode" ]; then
  step "расширения VS Code"
  have code || die "нет команды code"
  code --list-extensions | sort > vscode/extensions.txt
  ok "vscode/extensions.txt: $(wc -l < vscode/extensions.txt | tr -d ' ') шт."
fi
