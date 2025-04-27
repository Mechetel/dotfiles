return {
  {
    'alvan/vim-closetag',
    "jeetsukumaran/vim-indentwise",
    "tpope/vim-surround",
    "itchyny/vim-cursorword",
    'tpope/vim-repeat',
    "jszakmeister/vim-togglecursor",
    "editorconfig/editorconfig-vim",
    "tpope/vim-endwise",
    'thinca/vim-visualstar',

  },
  {
    'tpope/vim-unimpaired',
    config = function()
      vim.keymap.set('n', '<c-up>', '[e')
      vim.keymap.set('n', '<c-down>', ']e')
      vim.keymap.set('v', '<c-up>', '[egv')
      vim.keymap.set('v', '<c-down>', ']egv')
    end
  },
  {
    {
      "tpope/vim-commentary",
      config = function()
        vim.keymap.set("x", "#", "<Plug>Commentary", { silent = true })
        vim.keymap.set("o", "#", "<Plug>Commentary", { silent = true })
        vim.keymap.set("n", "#", "<Plug>CommentaryLine", { silent = true })
      end
    }
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
    }
  },
  {
    "haya14busa/is.vim",
    config = function()
      vim.g["is#do_default_mappings"] = 1
    end
  },
  {
    "haya14busa/vim-asterisk",
    config = function()
      vim.g["asterisk#keeppos"] = 1
      vim.keymap.set("n", "n", "<Plug>(is-n)zz", { silent = true })
      vim.keymap.set("n", "N", "<Plug>(is-N)zz", { silent = true })
      vim.keymap.set("n", "*", "<Plug>(asterisk-z*)zz<Plug>(is-nohl-1)", { silent = true })
      vim.keymap.set("n", "g*", "<Plug>(asterisk-gz*)zz<Plug>(is-nohl-1)", { silent = true })
    end
  },
  {
    "tpope/vim-speeddating",
    config = function()
      vim.g.speeddating_no_mappings = 1
      vim.keymap.set("n", "<C-A-X>", "<Plug>SpeedDatingUp")
      vim.keymap.set("n", "<C-X>", "<Plug>SpeedDatingDown")
    end
  }
}
