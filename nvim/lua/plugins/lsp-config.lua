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
          "rubocop",
          "ts_ls",
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
        "rubocop",
        "ruby_lsp",
        "purescriptls",
        "clangd",
      }

      for _, server in ipairs(servers) do
        vim.lsp.config(server, {
          capabilities = capabilities,
        })
      end

      -- Prevent RuboCop from trying to use its background server daemon,
      -- which causes "No such file or directory" errors on status file per project.
      vim.lsp.config("rubocop", {
        capabilities = capabilities,
        cmd = { "bundle", "exec", "rubocop", "--lsp", "--no-server" },
      })

      -- ruby-lsp answers semantic token requests Neovim has already cancelled,
      -- which shows up as "NO_RESULT_CALLBACK_FOUND"; treesitter highlights Ruby anyway.
      vim.lsp.config("ruby_lsp", {
        capabilities = capabilities,
        on_attach = function(client)
          client.server_capabilities.semanticTokensProvider = nil
        end,
      })

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
