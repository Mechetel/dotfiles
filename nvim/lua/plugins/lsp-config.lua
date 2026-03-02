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
          "lua_ls",
          "ruby_lsp",
          "ts_ls",
          "stimulus_ls",
          "rubocop",
          "hls",
        },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      local servers = {
        "ts_ls",
        "lua_ls",
        "stimulus_ls",
        "rubocop",
        "ruby_lsp",
        "hls",
        "purescriptls",
      }

      for _, server in ipairs(servers) do
        vim.lsp.config(server, {
          capabilities = capabilities,
        })
      end

      vim.lsp.enable(servers)

      vim.keymap.set("n", "<leader>K", vim.lsp.buf.hover, {})
      vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
      vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
      vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, { desc = "Format file" })
      vim.diagnostic.config({
        virtual_text = true, -- inline messages
        signs = true, -- signs in the gutter
        underline = true, -- underlines the word with issue
        update_in_insert = false, -- don't update while typing
        severity_sort = true, -- sort errors by severity
      })
    end,
  },
}
