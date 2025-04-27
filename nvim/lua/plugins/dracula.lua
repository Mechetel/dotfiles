return {
  "dracula/vim",
  lazy = false,
  name = "dracula",
  priority = 1000,
  config = function()
    vim.g.dracula_colorterm = 1
    vim.g.dracula_italic = 1

    vim.cmd.colorscheme "dracula"
  end
}
