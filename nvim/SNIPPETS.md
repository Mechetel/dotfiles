# Snippets in nvim

A snippet is a code template with placeholders you jump through with `Tab`.

## Where they come from

| Source | How it looks in the menu | What it gives you |
|---|---|---|
| **LuaSnip + friendly-snippets** | `Snippet`, `[rust]`/`[ruby]`... on the right | ready-made templates for dozens of languages |
| **Your own** - `~/.dotfiles/nvim/snippets/` | `Snippet` | whatever you wrote yourself |
| **LSP** (rust-analyzer, ruby-lsp...) | `Snippet` / `Keyword` | templates from the language server: `for`, `match`, `impl`... |

List all templates of the current language: `:lua for _,s in ipairs(require('luasnip').get_snippets(vim.bo.ft)) do print(s.trigger, s.name) end`

## How to use them

1. In insert mode start typing a prefix, e.g. `for`, `tmod`, `println`.
2. In the menu pick the entry of type **Snippet**: `Tab` / `Shift-Tab` move down/up the list. The right side shows what it expands to.
3. `Enter` expands it.
4. The cursor lands on the first placeholder (`${1:...}`). Type to replace its text.
5. `Tab` jumps to the next placeholder, `Shift-Tab` goes back. The last one (`$0`) is where the cursor ends up.

While the menu is open, `Tab` scrolls the menu instead of jumping through the template. Close the menu with `Ctrl-e` and press `Tab` again.

Other menu keys: `Ctrl-Space` opens it manually, `Ctrl-f` / `Ctrl-b` scroll the documentation on the right, `Ctrl-e` closes it.

## Useful built-ins for Rust

| Prefix | Expands to |
|---|---|
| `for` | `for pat in expr { todo!(); }` |
| `println`, `format`, `vec`, `assert_eq` | the matching macros with placeholders |
| `fn`, `pfn` | function / pub function |
| `struct`, `enum`, `impl`, `trait` | type skeletons |
| `match`, `if let`, `while let` | constructs with branches |
| `test`, `tmod` | a test / a test module (`tmod` is yours) |
| `dd` | `#[derive(Debug, Clone, PartialEq)]` (yours) |

## Adding your own

Put files in `~/.dotfiles/nvim/snippets/`, in the VS Code format:

```json
{
  "Name": {
    "prefix": "trigger",
    "body": [
      "a line with ${1:the first placeholder}",
      "and ${2:the second}, cursor at the end: $0"
    ],
    "description": "hint shown in the menu"
  }
}
```

- `${1:text}` is a placeholder with default text, `$1` is an empty one.
- The same number in two places (`$1 ... $1`) means you type once and both change.
- `${1|a,b,c|}` is a choice among options.
- `$0` is where the cursor finishes.

**For a new language** create `<language>.json` and add a line to `snippets/package.json`:

```json
{ "language": "ruby", "path": "./ruby.json" }
```

Restart nvim after editing.
