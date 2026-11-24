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
          require("conform").format({ async = true, lsp_format = "fallback" })
        end,
        mode = "",
        desc = "Format buffer",
      },
    },
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          lua = { "stylua" },
          rust = { "rustfmt" },
          c = { "clang-format" },
          cpp = { "clang-format" },
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
          -- ruby: no formatter here on purpose - the rubocop LSP formats it (see lsp-config.lua)
        },
        formatters = {
          -- Prettier only runs in projects that have a Prettier config. Most Rails/esbuild
          -- projects here do not, and running Prettier with its defaults reformats whole files.
          -- Without a config, conform falls back to the LSP formatter (lsp_format below).
          prettier = { require_cwd = true },
          prettierd = { require_cwd = true },
          stylua = {
            args = { "--indent-type", "Spaces", "--indent-width", "2", "-" },
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

      -- Ruby is linted by the rubocop LSP, not here (that produced duplicate diagnostics).
      lint.linters_by_ft = {
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescriptreact = { "eslint_d" },
      }

      -- Only a handful of projects have an ESLint config; elsewhere eslint_d would print
      -- "couldn't find a configuration file" on every save.
      local eslint_configs = {
        ".eslintrc", ".eslintrc.js", ".eslintrc.cjs", ".eslintrc.json", ".eslintrc.yml", ".eslintrc.yaml",
        "eslint.config.js", "eslint.config.mjs", "eslint.config.cjs", "eslint.config.ts",
      }

      local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
        group = lint_augroup,
        callback = function(args)
          local linters = lint.linters_by_ft[vim.bo[args.buf].filetype]
          if linters and vim.tbl_contains(linters, "eslint_d") and not vim.fs.root(args.buf, eslint_configs) then
            return
          end
          lint.try_lint()
        end,
      })
    end,
  },
}
