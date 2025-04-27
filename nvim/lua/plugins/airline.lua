return {
  "vim-airline/vim-airline",
  config = function()
    vim.g.airline_theme = "dracula"
    vim.g.airline_powerline_fonts = 1

    vim.g.airline_symbols = vim.g.airline_symbols or {}

    vim.g.airline_left_sep = '»'
    vim.g.airline_left_sep = '▶'
    vim.g.airline_right_sep = '«'
    vim.g.airline_right_sep = '◀'
    vim.g.airline_symbols.crypt = '🔒'
    vim.g.airline_symbols.linenr = '␊'
    vim.g.airline_symbols.linenr = '␤'
    vim.g.airline_symbols.linenr = '¶'
    vim.g.airline_symbols.maxlinenr = '☰'
    vim.g.airline_symbols.maxlinenr = ''
    vim.g.airline_symbols.branch = '⎇'
    vim.g.airline_symbols.paste = 'ρ'
    vim.g.airline_symbols.paste = 'Þ'
    vim.g.airline_symbols.paste = '∥'
    vim.g.airline_symbols.spell = 'Ꞩ'
    vim.g.airline_symbols.notexists = '∄'
    vim.g.airline_symbols.whitespace = 'Ξ'

    vim.g.airline_left_sep = ''
    vim.g.airline_left_alt_sep = ''
    vim.g.airline_right_sep = ''
    vim.g.airline_right_alt_sep = ''
    vim.g.airline_symbols.branch = ''
    vim.g.airline_symbols.readonly = ''
    vim.g.airline_symbols.linenr = ''

    vim.g["airline#extensions#tabline#enabled"] = 1
    vim.g["airline#extensions#tabline#buffer_idx_mode"] = 1
    vim.g["airline#extensions#syntastic#enabled"] = 1

    -- Key mappings for selecting tabs
    for i = 1, 9 do
      vim.keymap.set("n", "<leader>" .. i, "<Plug>AirlineSelectTab" .. i, { silent = true })
    end
  end,
}
