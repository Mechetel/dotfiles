local plugins = {
  { "christoomey/vim-tmux-navigator" },
}

if vim.env.TMUX ~= nil and vim.env.TMUX ~= "" then
  vim.list_extend(plugins, {
    { "tmux-plugins/vim-tmux" },
    { "wellle/tmux-complete.vim" },
    {
      "benmills/vimux",
      config = function()
        vim.g.VimuxRunnerType = "window"
        vim.g.VimuxUseNearest = 0

        vim.keymap.set("n", "<leader>tt", ":VimuxTogglePane<CR>", { silent = true })
        vim.keymap.set("n", "<leader>to", ":call VimuxOpenRunner()<CR>", { silent = true })
        vim.keymap.set("n", "<leader>tl", ":VimuxRunLastCommand<CR>", { silent = true })
        vim.keymap.set("n", "<leader>tr", ":call VimuxRunCommand('yr run && cat output/pipePFn.d.ts')<CR>", { silent = true })

        vim.api.nvim_create_autocmd("VimEnter", {
          pattern = "*",
          callback = function()
            vim.fn.system("tmux source ~/.dotfiles/tmux/themes/dracula_tmuxline_new.conf")
          end,
        })

        vim.api.nvim_create_autocmd("VimLeave", {
          pattern = "*",
          callback = function()
            vim.fn.system("tmux source ~/.dotfiles/tmux/themes/dracula_tmuxline_new.conf")
          end,
        })
      end
    },
    {
      "edkolev/tmuxline.vim",
      config = function()
        vim.g.tmuxline_theme = "dracula"
        vim.g.tmuxline_preset = "minimal"
      end
    }
  })
end

return plugins
