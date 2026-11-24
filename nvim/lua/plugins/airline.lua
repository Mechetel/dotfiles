return {
  "vim-airline/vim-airline",
  -- Everything that affects symbols MUST be set in `init` (before the plugin loads):
  -- vim-airline fills in its symbol defaults while it is being sourced, which happens
  -- before lazy.nvim runs `config`. Setting these in `config` is too late, and airline then
  -- keeps its non-Powerline defaults (e.g. the runic U+16A0 as the git branch symbol).
  init = function()
    vim.g.airline_theme = "dracula"
    vim.g.airline_powerline_fonts = 1

    -- Powerline glyphs, written as codepoints so they are visible in this file.
    -- They need a Powerline/Nerd Font: kitty maps U+E0A0-E0A3 and U+E0B0-E0D4 to
    -- "Hack Nerd Font Mono" (see kitty/kitty.conf).
    vim.g.airline_left_sep = "\u{e0b0}"
    vim.g.airline_left_alt_sep = "\u{e0b1}"
    vim.g.airline_right_sep = "\u{e0b2}"
    vim.g.airline_right_alt_sep = "\u{e0b3}"

    -- Assign the whole dictionary at once: `vim.g.airline_symbols.branch = x` modifies a
    -- temporary copy and is silently lost. Keys not listed here get airline's defaults.
    vim.g.airline_symbols = {
      branch = "\u{e0a0}",
      readonly = "\u{e0a2}",
      linenr = "\u{e0a1}",
      maxlinenr = "",
      paste = "∥",
      spell = "Ꞩ",
      notexists = "∄",
      whitespace = "Ξ",
    }

    vim.g["airline#extensions#tabline#enabled"] = 1
    vim.g["airline#extensions#tabline#buffer_idx_mode"] = 1
  end,
  config = function()
    -- Key mappings for selecting tabs
    for i = 1, 9 do
      vim.keymap.set("n", "<leader>" .. i, "<Plug>AirlineSelectTab" .. i, { silent = true })
    end
  end,
}
