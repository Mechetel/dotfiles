return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls", "ruby_lsp", "ts_ls", "stimulus_ls", "rubocop"
        }
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      local lspconfig = require("lspconfig")
      lspconfig.ts_ls.setup({capabilities = capabilities})
      lspconfig.lua_ls.setup({capabilities = capabilities})
      lspconfig.stimulus_ls.setup({capabilities = capabilities})
      lspconfig.rubocop.setup({capabilities = capabilities})
      lspconfig.ruby_lsp.setup({capabilities = capabilities})
      vim.keymap.set("n", "<leader>K", vim.lsp.buf.hover, {})
      vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
      vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
      vim.diagnostic.config({
        virtual_text = true,      -- inline messages
        signs = true,             -- signs in the gutter
        underline = true,         -- underlines the word with issue
        update_in_insert = false, -- don't update while typing
        severity_sort = true,     -- sort errors by severity
      })
    end,
  },
}
