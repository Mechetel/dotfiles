return {
  {
    "alvan/vim-closetag",
    "itchyny/vim-cursorword",
    "jszakmeister/vim-togglecursor",
    "editorconfig/editorconfig-vim",
    "tpope/vim-endwise",
    "thinca/vim-visualstar",
    "tommcdo/vim-exchange",
    "tpope/vim-fugitive",
  },
  {
    "myusuf3/numbers.vim",
    config = function()
      vim.keymap.set("n", "<F7>", "<Cmd>NumbersToggle<CR>", {})
    end,
  },
  {
    "jiangmiao/auto-pairs",
    init = function()
      vim.g.AutoPairsShortcutToggle = ""
      vim.g.AutoPairsMapCh = 0
      vim.g.AutoPairsFlyMode = 0
      vim.g.AutoPairsShortcutBackInsert = ""
      vim.g.AutoPairsMultilineClose = 0
    end,
  },
  {
    "zhaocai/GoldenView.Vim",
    config = function()
      vim.g.goldenview__enable_default_mapping = 0
    end,
    init = function()
      vim.g.mapleader = vim.g.mapleader or ","
    end,
    keys = {
      { "<Plug>ToggleGoldenViewAutoResize", mode = { "n", "v" } },
    },
  },
  {
    "haya14busa/is.vim",
    config = function()
      vim.g["is#do_default_mappings"] = 1
    end,
  },
  {
    "haya14busa/vim-asterisk",
    config = function()
      vim.g["asterisk#keeppos"] = 1
      vim.keymap.set("n", "n", "<Plug>(is-n)zz", { silent = true })
      vim.keymap.set("n", "N", "<Plug>(is-N)zz", { silent = true })
      vim.keymap.set("n", "*", "<Plug>(asterisk-z*)zz<Plug>(is-nohl-1)", { silent = true })
      vim.keymap.set("n", "g*", "<Plug>(asterisk-gz*)zz<Plug>(is-nohl-1)", { silent = true })
    end,
  },
  {
    "folke/trouble.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = true,
  },
  {
    "justinmk/vim-sneak",
    init = function()
      vim.g["sneak#streak"] = 1
      vim.g["sneak#label"] = 1
    end,
  },
}
