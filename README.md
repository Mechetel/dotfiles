# dotfiles

macOS environment configs: zsh (oh-my-zsh + powerlevel10k), tmux, neovim, kitty, git, ranger,
Karabiner, VS Code. Everything installs with one command and **always gets the latest
versions** (nothing is pinned in the `Brewfile`).

## Install on a new Mac

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Mechetel/dotfiles/master/bootstrap.sh)"
```

The script installs the Xcode Command Line Tools, clones this repository into `~/.dotfiles`
and runs `install.sh`. The manual equivalent:

```bash
git clone https://github.com/Mechetel/dotfiles.git ~/.dotfiles
~/.dotfiles/install.sh
```

`install.sh` flags (they can also be passed to `bootstrap.sh`):

| Flag | What it does |
|---|---|
| `--dry-run` | show the steps without changing anything |
| `--no-apps` | skip GUI applications (`Brewfile.apps`) |
| `--no-brew` | skip brew entirely - only links and shell setup |
| `--no-vscode` | do not install VS Code extensions |
| `--macos` | apply macOS system defaults (`scripts/macos.sh`) |

The installer is idempotent, so it is safe to re-run after a `git pull`. Existing files are
**never overwritten**: they are moved to `~/.dotfiles-backup/<timestamp>/`.

### What happens, step by step

1. **Homebrew** (if missing) -> `Brewfile` (CLI, runtimes, fonts) -> `Brewfile.apps` (GUI, Mac App Store)
2. **oh-my-zsh**, plugins (autosuggestions, syntax-highlighting, completions), **powerlevel10k**, **tpm** - `scripts/shell.sh`
3. The "Fira Code Freeze" font from `fonts/` -> `~/Library/Fonts`
4. **Symlinks** into `$HOME` - `scripts/link.sh`
5. Local files `~/.gitconfig.local` and `~/.zshrc.local` (never tracked)
6. VS Code extensions (`vscode/extensions.txt`) and neovim plugins (pinned by `nvim/lazy-lock.json`)

### Still manual

No secrets are stored in this repository - it is public.

- `gh auth login`, `glab auth login`
- SSH and GPG keys: restore them from your password manager / backup (`gpg-backup` and
  `gpg-restore` use `~/.local/share/gpg-backup`, never the repository)
- Ruby: install [rvm](https://rvm.io), then `rvm install <version>`
- Node: `nvm install --lts` (nvm is lazy-loaded)
- Karabiner-Elements and Docker Desktop: first launch and permissions in System Settings
- Apps outside brew: Adobe CC, Microsoft Office, Mathematica, ClearVPN, Folx, ...

## Layout

```
bootstrap.sh          # curl entry point: CLT + clone + install.sh
install.sh            # orchestrator
Brewfile              # CLI, runtimes, fonts (unpinned)
Brewfile.apps         # GUI applications and Mac App Store
bin/git-lc            # linted git commit (see below); bin/ is on PATH
scripts/
  link.sh             # symlinks with backup (+ --dry-run); the file list is the LINKS array
  shell.sh            # oh-my-zsh, plugins, p10k, tpm
  macos.sh            # defaults write (opt-in via --macos)
  snapshot.sh         # installed but not in the Brewfiles; --vscode refreshes extensions
  doctor.sh           # checks links, tools, secrets and zsh startup time
tests/git-lc.test.sh  # tests for git-lc
zshrc  zsh/*.sh       # zsh config; aliases/functions/key bindings split by topic
p10k.zsh starship.toml
gitconfig gitignore_global
tmux.conf tmux/       # + dracula theme and key bindings
nvim/                 # lazy.nvim; lazy-lock.json pins plugin versions
kitty/ karabiner/ ranger/ vscode/ fonts/
archive/              # old stuff (nvim-old, zsh-trash) - not used
```

## git-lc: linted commits without npm

`bin/git-lc` is a dependency-free bash replacement for the `commitlint` +
`linted-git-commit` npm packages. It checks the message against Conventional Commits and
only then runs `git commit`:

```bash
lc -m "feat(auth): add login"        # alias for git-lc; `git lc ...` works too
lc -m "fix: bug" -m "Details..."     # several -m become paragraphs
lcn -m "chore: wip"                  # --no-verify
lc! -m "fix: typo"                   # --amend
git-lc --check .git/COMMIT_EDITMSG   # lint only (or `-` for stdin); usable as a commit-msg hook
git-lc -h                            # types and rules
```

Types: `chore ci feat fix docs style refactor perf test revert`. The rules follow
`@commitlint/config-conventional`: lower-case type and scope, non-empty subject that does not
start with a capital letter or end with a period, lines of at most 100 characters.
`Merge`, `Revert "..."` and `fixup!`/`squash!` messages are skipped. To change the allowed
types or rules, edit the top of the script. Run `tests/git-lc.test.sh` after any change.

## Neovim (tuned for Rails + Slim/ERB + Stimulus)

Plugins are pinned by `nvim/lazy-lock.json`; the first launch on a new machine installs the
plugins, treesitter parsers, language servers and formatters (mason-tool-installer).

- **Ruby:** RuboCop (through the project's bundle) is the only source of style diagnostics
  and formatting; ruby-lsp handles navigation, completion and syntax errors. RuboCop starts
  only in projects with a `.rubocop.yml` or `bin/rubocop`.
- **Formatting:** `,gf` (conform). Prettier runs only in projects that have a Prettier
  config, otherwise the LSP formatter is used; ESLint runs only where an ESLint config exists.
- **Rails:** `tpope/vim-rails` (`:A` alternate file, `:Emodel`, `gf` on partials), tag
  auto-closing in `*.erb`.
- **Tests in tmux (vimux):** `,ts` runs the current test file, `,tr` the nearest test.
  From `app/models/user.rb` it finds `spec/models/user_spec.rb` (RSpec) or
  `test/models/user_test.rb` (Minitest).
- **Search:** `,ff` files, `,fg` grep, `,fw` word under cursor, `,fb` buffers, `,fr`
  resume, `,fd` diagnostics, `,fs` symbols; `log/`, `tmp/`, `node_modules/`, `public/assets/`
  are ignored. LSP: `,gd` `,gr` `,ca` `,rn` (rename) `,e` (diagnostic float).
- Trailing whitespace is stripped on save, except in Markdown, diffs and commit messages.

## Day-to-day

```bash
scripts/doctor.sh          # is everything in place, any secrets, how fast does zsh start
scripts/snapshot.sh        # what did I install on this Mac and forget to record
scripts/link.sh --dry-run
```

**Add a new config:** put the file in the repository and add a line to the `LINKS` array in
`scripts/link.sh`: `"path-in-repo|path-from-$HOME"`.

**Installed a new program:** add it to `Brewfile` / `Brewfile.apps` (`scripts/snapshot.sh`
tells you what is missing) and commit.

**Settings for this computer only** (tokens, pinned versions): `~/.zshrc.local` and
`~/.gitconfig.local`. They are not tracked. Example: on the old Mac `~/.zshrc.local` holds
`path=(/usr/local/opt/node@20/bin /usr/local/opt/mysql@5.7/bin $path)`.

## Notes

- Works on Intel (`/usr/local`) and Apple Silicon (`/opt/homebrew`): the brew prefix is
  detected automatically and there is no `/Users/<name>` in any path.
- zsh starts in ~0.5 s (it was ~1.8 s): `nvm` is lazy-loaded and oh-my-zsh update checks are off.
- The repository is public: `.gitignore` blocks `secrets/`, `*.local`, keys and tokens, and
  `scripts/doctor.sh` scans tracked files for anything that looks like a secret.
