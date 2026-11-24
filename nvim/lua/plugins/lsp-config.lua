return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    -- One place that installs everything nvim needs on a fresh machine: language servers
    -- (names are mason package names), plus the formatters/linters that conform.nvim and
    -- nvim-lint call. Replaces manual `npm i -g` / `:MasonInstall` steps.
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-tool-installer").setup({
        ensure_installed = {
          -- language servers
          "lua-language-server",
          "ruby-lsp",
          "typescript-language-server",
          "css-lsp",
          "json-lsp",
          -- formatters / linters
          "stylua",
          "prettier",
          "prettierd",
          "eslint_d",
        },
      })
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      -- Servers are enabled explicitly below; do not let mason enable everything installed.
      -- (Installing is done by mason-tool-installer above.)
      require("mason-lspconfig").setup({ automatic_enable = false })
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
        "cssls",
        "jsonls",
        "purescriptls",
        "clangd",
      }

      for _, server in ipairs(servers) do
        vim.lsp.config(server, {
          capabilities = capabilities,
        })
      end

      -- RuboCop is the single source of Ruby style diagnostics and formatting.
      --  * It runs through the project's bundle (`bundle exec`), so it always matches the
      --    project's rubocop version and config (the omakase/rails cops differ per project).
      --  * `--no-server` avoids the background daemon, which fails on its per-project status file.
      --  * It only starts in projects that actually have RuboCop set up; otherwise
      --    `bundle exec rubocop` exits with code 1 and nvim shows "Client rubocop quit".
      vim.lsp.config("rubocop", {
        capabilities = capabilities,
        cmd = { "bundle", "exec", "rubocop", "--lsp", "--no-server" },
        root_dir = function(bufnr, on_dir)
          local root = vim.fs.root(bufnr, { ".rubocop.yml", "bin/rubocop" })
          if root then
            on_dir(root)
          end
        end,
      })

      vim.lsp.config("ruby_lsp", {
        capabilities = capabilities,
        -- ruby-lsp would run RuboCop on its own, so every offense showed up twice (once per
        -- client). Keep ruby-lsp for navigation/completion/Prism syntax errors and leave
        -- linting and formatting to the rubocop client above.
        init_options = {
          formatter = "none",
          linters = {},
        },
        -- ruby-lsp answers semantic token requests Neovim has already cancelled,
        -- which shows up as "NO_RESULT_CALLBACK_FOUND"; treesitter highlights Ruby anyway.
        on_attach = function(client)
          client.server_capabilities.semanticTokensProvider = nil
        end,
      })

      vim.lsp.enable(servers)

      vim.keymap.set("n", "<leader>K", vim.lsp.buf.hover, {})
      vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
      vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
      vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic" })
      vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, { desc = "Format file" })
      vim.diagnostic.config({
        virtual_text = true, -- inline messages
        signs = true, -- signs in the gutter
        underline = true, -- underlines the word with issue
        update_in_insert = false, -- don't update while typing
        severity_sort = true, -- sort errors by severity
        float = { border = "rounded", source = true }, -- show which tool reported it
      })
    end,
  },
}
