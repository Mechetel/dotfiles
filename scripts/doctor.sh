#!/usr/bin/env bash
# Проверка здоровья: симлинки, инструменты, секреты в репозитории, скорость старта zsh.
#   scripts/doctor.sh
set -uo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
cd "$DOTFILES"
fail=0

step "Симлинки"
DRY_RUN=1 "$DOTFILES/scripts/link.sh" --dry-run 2>&1 | grep -E 'бэкап|готово|нет источника' | sed 's/^/ /'
DRY_RUN=1 "$DOTFILES/scripts/link.sh" --dry-run 2>&1 | grep -q 'в бэкап 0' && ok "все ссылки на месте" || { warn "есть расхождения — запусти scripts/link.sh"; fail=1; }

step "Инструменты"
for t in git zsh tmux nvim fzf rg fd gh diff-so-fancy starship; do
  if have "$t"; then ok "$t"; else warn "нет $t"; fail=1; fi
done
for d in "$HOME/.oh-my-zsh" "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" "$HOME/.tmux/plugins/tpm"; do
  [ -d "$d" ] && ok "${d/#$HOME/~}" || { warn "нет ${d/#$HOME/~} — scripts/shell.sh"; fail=1; }
done

step "Секреты в отслеживаемых файлах (репозиторий публичный!)"
pat='(ghp_[A-Za-z0-9]{20,}|glpat-[A-Za-z0-9_-]{20}|AKIA[0-9A-Z]{16}|sk-[A-Za-z0-9]{32,}|-----BEGIN [A-Z ]*PRIVATE KEY-----|_authToken=[^$ ]+|password *= *[^ ]+)'
if git ls-files -z | xargs -0 grep -InE "$pat" 2>/dev/null | grep -v 'scripts/doctor.sh' | head -5 | grep .; then
  err "найдено похожее на секрет (см. выше)"; fail=1
else
  ok "ничего похожего на токены/ключи"
fi
git check-ignore -q secrets/x && ok "secrets/ в .gitignore" || { warn "secrets/ не в .gitignore"; fail=1; }

step "Скорость запуска zsh (3 прогона)"
if have zsh; then
  for _ in 1 2 3; do
    s=$(python3 -c 'import time;print(int(time.time()*1e9))')
    zsh -i -c exit >/dev/null 2>&1
    e=$(python3 -c 'import time;print(int(time.time()*1e9))')
    printf '  %d ms\n' $(( (e - s) / 1000000 ))
  done
  info "цель: < 400 ms. Профиль: zsh -i -c 'zmodload zsh/zprof; source ~/.zshrc; zprof | head'"
fi

exit $fail
