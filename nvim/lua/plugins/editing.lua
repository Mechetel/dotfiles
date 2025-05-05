return {
  {
    "jeetsukumaran/vim-indentwise",
    "tpope/vim-repeat",
    "tpope/vim-surround",
    "tpope/vim-abolish",
    "AndrewRadev/switch.vim",
    "AndrewRadev/deleft.vim", -- dh in normal mode
  },
  {
    'junegunn/vim-easy-align',
    config = function()
      vim.keymap.set("x", "ga", "<Plug>(EasyAlign)", { noremap = false })
      vim.keymap.set("n", "ga", "<Plug>(EasyAlign)", { noremap = false })
    end,
  },
  {
    "tpope/vim-commentary",
    config = function()
      vim.keymap.set("x", "#", "<Plug>Commentary", { silent = true })
      vim.keymap.set("o", "#", "<Plug>Commentary", { silent = true })
      vim.keymap.set("n", "#", "<Plug>CommentaryLine", { silent = true })
    end
  },
}
