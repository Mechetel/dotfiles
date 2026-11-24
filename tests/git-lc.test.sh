#!/usr/bin/env bash
# Tests for bin/git-lc:  tests/git-lc.test.sh   (run under /bin/bash 3.2 and under a newer bash)
cd "$(dirname "$0")/.." || exit 1
LC=bin/git-lc
pass=0; fail=0

expect() { # ok|bad  "message"  [expected rule name]
  local want="$1" msg="$2" rule="${3:-}" out rc
  out=$(printf '%s' "$msg" | "$LC" --check - 2>&1); rc=$?
  if [ "$want" = ok ] && [ $rc -eq 0 ]; then pass=$((pass+1))
  elif [ "$want" = bad ] && [ $rc -eq 1 ] && { [ -z "$rule" ] || printf '%s' "$out" | grep -q "\[$rule\]"; }; then pass=$((pass+1))
  else fail=$((fail+1)); printf 'FAIL (%s, rc=%s, expected %s): %q\n%s\n' "$want" "$rc" "${rule:-—}" "$msg" "$out"; fi
}

# valid
expect ok "feat: add login"
expect ok "fix(auth): handle empty token"
expect ok "feat(api)!: drop v1 endpoints"
expect ok "chore: bump deps"
expect ok "revert: undo 1234"
expect ok $'feat: add x\n\nbody line one\nbody line two'
expect ok "Merge branch 'main' into feat/x"
expect ok 'Revert "feat: add x"'
expect ok "fixup! feat: add x"
expect ok $'feat: add x\n# git comment line\n'
# invalid
expect bad ""                                   subject-empty
expect bad "add login"                          type-empty
expect bad "feature: add login"                 type-enum
expect bad "build: new bundler"                 type-enum
expect bad "Feat: add login"                    type-case
expect bad "feat(Auth): add login"              scope-case
expect bad "feat: "                             subject-empty
expect bad "feat:"                              subject-empty
expect bad "feat: Add login"                    subject-case
expect bad "feat: ADD LOGIN"                    subject-case
expect bad "feat: add login."                   subject-full-stop
expect bad "feat: $(printf 'a%.0s' $(seq 1 100))" header-max-length
expect bad $'feat: add x\n'"$(printf 'b%.0s' $(seq 1 101))" body-max-line-length
# a warning (no blank line after the header) does not block
expect ok $'feat: add x\nbody right after header'

# git integration: rejects bad messages, commits good ones, forwards flags
t=$(mktemp -d); ( cd "$t" && git init -q && git config user.email t@t && git config user.name t && echo 1 > f && git add f
  if "$OLDPWD/$LC" -m "Bad message" >/dev/null 2>&1; then echo "FAIL: bad commit went through"; exit 1; fi
  [ -z "$(git log --oneline 2>/dev/null)" ] || { echo "FAIL: commit created despite lint error"; exit 1; }
  "$OLDPWD/$LC" -m "feat: first" -m "details here" >/dev/null 2>&1 || { echo "FAIL: good commit was rejected"; exit 1; }
  [ "$(git log -1 --format=%B | sed -n 3p)" = "details here" ] || { echo "FAIL: second -m was lost"; exit 1; }
  echo 2 > f; "$OLDPWD/$LC" -am "fix: second" >/dev/null 2>&1 || { echo "FAIL: -am"; exit 1; }
  [ "$(git log --format=%s | head -1)" = "fix: second" ] || { echo "FAIL: -am did not commit"; exit 1; }
  "$OLDPWD/$LC" --amend -m "fix: second renamed" >/dev/null 2>&1 || { echo "FAIL: --amend"; exit 1; }
  [ "$(git rev-list --count HEAD)" = 2 ] && [ "$(git log -1 --format=%s)" = "fix: second renamed" ] || { echo "FAIL: amend"; exit 1; }
) || fail=$((fail+1)); rm -rf "$t"

echo "passed: $pass, failed: $fail"
[ $fail -eq 0 ]
