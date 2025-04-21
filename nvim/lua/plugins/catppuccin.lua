return {
  "catppuccin/nvim",
  lazy = false,
  name = "catppuccin",
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      styles = {
        comments = { "italic" },  -- тільки коментарі курсивом
      },
    })

    vim.cmd.colorscheme "catppuccin-mocha"
  end
}
