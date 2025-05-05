return {
  "mhinz/vim-sayonara",
  config = function()
    vim.keymap.set("n", "Q", "<Cmd>Sayonara<CR>", { noremap = true })
    vim.keymap.set("n", "<M-q>", "<Cmd>Sayonara!<CR>", { noremap = true })
    vim.keymap.set("n", "<leader>q", "<Cmd>xa<CR>", { noremap = true })
    vim.keymap.set("n", "<leader>z", "<Cmd>qa!<CR>", { noremap = true })
  end,
}
