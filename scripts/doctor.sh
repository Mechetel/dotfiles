#!/usr/bin/env bash
# Health check: symlinks, tools, secrets in the repository, zsh startup time.
#   scripts/doctor.sh
set -uo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
cd "$DOTFILES"
fail=0

step "Symlinks"
if DRY_RUN=1 "$DOTFILES/scripts/link.sh" --dry-run 2>&1 | grep -q 'done: 0 new,.* 0 backed up'; then
  ok "all links are in place"
else
  warn "links differ - run scripts/link.sh (scripts/link.sh --dry-run shows what would change)"; fail=1
fi

step "Tools"
for t in git zsh tmux nvim fzf rg fd gh diff-so-fancy starship; do
  if have "$t"; then ok "$t"; else warn "missing: $t"; fail=1; fi
done
for d in "$HOME/.oh-my-zsh" "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" "$HOME/.tmux/plugins/tpm"; do
  [ -d "$d" ] && ok "${d/#$HOME/~}" || { warn "missing ${d/#$HOME/~} - run scripts/shell.sh"; fail=1; }
done
[ -x "$DOTFILES/bin/git-lc" ] && ok "bin/git-lc" || { warn "bin/git-lc is not executable"; fail=1; }

step "Secrets in tracked files (the repository is public!)"
pat='(ghp_[A-Za-z0-9]{20,}|glpat-[A-Za-z0-9_-]{20}|AKIA[0-9A-Z]{16}|sk-[A-Za-z0-9]{32,}|-----BEGIN [A-Z ]*PRIVATE KEY-----|_authToken=[^$ ]+|password *= *[^ ]+)'
if git ls-files -z | xargs -0 grep -InE "$pat" 2>/dev/null | grep -v 'scripts/doctor.sh' | head -5 | grep .; then
  err "found something that looks like a secret (see above)"; fail=1
else
  ok "nothing that looks like a token or key"
fi
git check-ignore -q secrets/x && ok "secrets/ is in .gitignore" || { warn "secrets/ is not in .gitignore"; fail=1; }

step "zsh startup time (3 runs)"
if have zsh; then
  for _ in 1 2 3; do
    s=$(python3 -c 'import time;print(int(time.time()*1e9))')
    zsh -i -c exit >/dev/null 2>&1
    e=$(python3 -c 'import time;print(int(time.time()*1e9))')
    printf '  %d ms\n' $(( (e - s) / 1000000 ))
  done
  info "target: < 400 ms. Profile: zsh -i -c 'zmodload zsh/zprof; source ~/.zshrc; zprof | head'"
fi

exit $fail
