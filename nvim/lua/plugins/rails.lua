-- Rails: most of the projects in ~/Projects are Rails apps with ERB or Slim views.
return {
  {
    -- :A / :R alternate files (model <-> spec), :Emodel/:Econtroller/:Eview, `gf` on partials,
    -- `:Rails` console/server helpers, routes and schema awareness. Detects Rails apps by itself.
    "tpope/vim-rails",
    lazy = false,
  },
  {
    -- Auto-close tags in ERB too (the default only covers *.html).
    "alvan/vim-closetag",
    init = function()
      vim.g.closetag_filenames = "*.html,*.html.erb,*.erb,*.xml,*.jsx,*.tsx"
    end,
  },
}
