return {
  'romgrk/replace.vim',
  init = function()
    vim.g.replace_register = '_' -- використовувати чорну діру як реєстр
  end,
  config = function()
    -- Операції заміни/обміну
    vim.keymap.set("n", "R", '"+<Plug>ReplaceOperator', { noremap = false })
    vim.keymap.set("v", "R", '"+<Plug>ReplaceOperator', { noremap = false })

    vim.keymap.set("n", "X", '"+<Plug>ExchangeOperator', { noremap = false })

    -- Заміна поточного рядка на вміст з буфера +
    vim.keymap.set("n", "RR", 'cc<C-R>+<Esc>', { noremap = true })
  end,
}
