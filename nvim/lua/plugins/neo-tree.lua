return {
  "preservim/nerdtree",
  dependencies = {
    "ryanoasis/vim-devicons",
  },
  event = "VeryLazy",
  config = function()
    -- NERDTree settings
    vim.g.NERDTreeLimitedSyntax = 1
    vim.g.NERDTreeHighlightCursorline = 0
    vim.g.NERDTreeShowHidden = 1
    vim.g.NERDTreeQuitOnOpen = 0
    vim.g.NERDTreeShowLineNumbers = 1
    vim.g.NERDTreeChDirMode = 0
    vim.g.NERDTreeShowBookmarks = 1
    vim.g.NERDTreeIgnore = {
      "\\.git$",
      "\\.hg$",
      "\\node_modules$",
      "\\.pyc$",
      "^__generated__$",
      "\\.agdai$",
      "\\.agda\\.vim$",
    }
    vim.g.NERDTreeBookmarksFile = vim.fn.stdpath('cache') .. '/NERDTreeBookmarks'

    -- Key mappings
    vim.g.NERDTreeMapOpenVSplit = "V"
    vim.g.NERDTreeMapToggleFiles = ""
    vim.g.NERDTreeMapToggleFilters = ""
    vim.g.NERDTreeMapHelp = "<M-/>"
    vim.g.NERDTreeMapQuit = "Q"

    -- Bindings
    vim.keymap.set("n", "<F2>", ":NERDTreeToggle<CR>", { noremap = true, silent = true })
    vim.keymap.set("n", "<F3>", ":NERDTreeFind<CR>", { noremap = true, silent = true })
  end,
}
