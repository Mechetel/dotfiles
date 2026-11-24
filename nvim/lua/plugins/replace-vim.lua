return {
  'romgrk/replace.vim',
  init = function()
    vim.g.replace_register = '_' -- use the black hole as the register
  end,
  config = function()
    -- Replace/exchange operators
    vim.keymap.set("n", "R", '"+<Plug>ReplaceOperator', { noremap = false })
    vim.keymap.set("v", "R", '"+<Plug>ReplaceOperator', { noremap = false })

    vim.keymap.set("n", "X", '"+<Plug>ExchangeOperator', { noremap = false })

    -- Replace the current line with the contents of the + register
    vim.keymap.set("n", "RR", 'cc<C-R>+<Esc>', { noremap = true })
  end,
}
