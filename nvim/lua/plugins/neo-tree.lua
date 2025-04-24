return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  config = function()
    require("neo-tree").setup({
      default_component_configs = {
        git_status = {
          symbols = {
            added     = "✚",
            deleted   = "✖",
            modified  = "",
            renamed   = "󰁕",
            untracked = "",
            ignored   = "◌",
            unstaged  = "󰄱",
            staged    = "",
            conflict  = "",
          },
        },
      },
      filesystem = {
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_by_name = {
            ".DS_Store",
            "thumbs.db",
            ".git",
          },
        },
      },
    })
    vim.keymap.set("n", "<F1>", ":Neotree reveal<CR>", {})
    vim.keymap.set("n", "<F2>", ":Neotree filesystem toggle left<CR>", {})
    vim.keymap.set("n", "<F3>", ":Neotree buffers toggle float<CR>", {})
    vim.keymap.set("n", "<F4>", ":Neotree git_status toggle float<CR>", {})
  end,
}
