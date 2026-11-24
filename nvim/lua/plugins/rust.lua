-- Rust: rustaceanvim drives rust-analyzer (installed via `brew install rust-analyzer`),
-- so rust_analyzer must NOT also be enabled in lsp-config.lua.
return {
  {
    "mrcjkb/rustaceanvim",
    version = "^9",
    lazy = false, -- the plugin lazy-loads itself on Rust files
    init = function()
      vim.g.rustaceanvim = {
        server = {
          on_attach = function(_, bufnr)
            local map = function(lhs, rhs, desc)
              vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
            end
            map("<leader>ca", function() vim.cmd.RustLsp("codeAction") end, "Rust code action")
            map("<leader>K", function() vim.cmd.RustLsp({ "hover", "actions" }) end, "Rust hover actions")
            map("<leader>rr", function() vim.cmd.RustLsp("runnables") end, "Rust runnables")
            map("<leader>rt", function() vim.cmd.RustLsp("testables") end, "Rust testables")
            map("<leader>re", function() vim.cmd.RustLsp("explainError") end, "Rust explain error")
            map("<leader>rm", function() vim.cmd.RustLsp("expandMacro") end, "Rust expand macro")
            vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
          end,
          default_settings = {
            ["rust-analyzer"] = {
              cargo = { allFeatures = true },
              check = { command = "clippy" },
            },
          },
        },
      }
    end,
  },
  {
    "saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    opts = {
      lsp = { enabled = true, actions = true, completion = true, hover = true },
    },
  },
}
