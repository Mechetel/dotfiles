return {
  -- Formatting with conform.nvim
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>gf",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        mode = "",
        desc = "Format buffer",
      },
    },
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          lua = { "stylua" },
          javascript = { "prettierd", "prettier", stop_after_first = true },
          typescript = { "prettierd", "prettier", stop_after_first = true },
          javascriptreact = { "prettierd", "prettier", stop_after_first = true },
          typescriptreact = { "prettierd", "prettier", stop_after_first = true },
          json = { "prettierd", "prettier", stop_after_first = true },
          html = { "prettierd", "prettier", stop_after_first = true },
          css = { "prettierd", "prettier", stop_after_first = true },
          scss = { "prettierd", "prettier", stop_after_first = true },
          markdown = { "prettierd", "prettier", stop_after_first = true },
          yaml = { "prettierd", "prettier", stop_after_first = true },
          -- ruby = { "rubocop" }, -- Using rubocop via LSP instead
        },
        formatters = {
          stylua = {
            args = { "--indent-type", "Spaces", "--indent-width", "2", "-" },
          },
          rubocop = {
            timeout_ms = 5000,
            cwd = require("conform.util").root_file({ "bin/rubocop", ".rubocop.yml" }),
            command = function(self, ctx)
              local rubocop_bin = vim.fs.find("bin/rubocop", { path = ctx.dirname, upward = true })[1]
              if rubocop_bin then
                return vim.fs.dirname(rubocop_bin) .. "/rubocop"
              end
              return "rubocop"
            end,
          },
        },
        -- -- Format on save (optional)
        -- format_on_save = {
        --   -- These options will be passed to conform.format()
        --   timeout_ms = 500,
        --   lsp_fallback = true,
        -- },
      })
    end,
  },

  -- Linting with nvim-lint
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")

      lint.linters_by_ft = {
        ruby = { "rubocop" }, -- Using rubocop via LSP instead
        -- Remove or comment out these if you don't have eslint_d installed
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescriptreact = { "eslint_d" },
      }

      -- Configure rubocop linter
      lint.linters.rubocop.cmd = function()
        local rubocop_bin = vim.fs.find("bin/rubocop", { upward = true })[1]
        if rubocop_bin then
          return vim.fs.dirname(rubocop_bin) .. "/rubocop"
        end
        return "rubocop"
      end

      -- Create autocommand to lint on specific events
      local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = lint_augroup,
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },
}
