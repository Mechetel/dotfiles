return {
  {
    "nvim-telescope/telescope-ui-select.nvim",
  },
  {
    "nvim-telescope/telescope.nvim",
    tag = "v0.2.2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup({
        defaults = {
          file_ignore_patterns = {
            "^%.git/", "node_modules/", "%.ruby%-lsp/", "^log/", "^tmp/", "^coverage/",
            "^public/assets/", "^public/packs/", "^vendor/bundle/", "^app/assets/builds/",
          },
          layout_strategy = "horizontal",
          layout_config = {
            height = 0.99,
            width = 0.99,
          },
        },
        pickers = {
          find_files = { hidden = true }, -- .rubocop.yml, .env.example, .github/ ...
        },
        extensions = { ["ui-select"] = { require("telescope.themes").get_dropdown({}) } },
      })
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
      vim.keymap.set("n", "<leader><leader>", builtin.oldfiles, {})
      vim.keymap.set("n", "<leader>fw", builtin.grep_string, { desc = "Grep word under cursor" })
      vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Buffers" })
      vim.keymap.set("n", "<leader>fr", builtin.resume, { desc = "Resume last picker" })
      vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "Diagnostics" })
      vim.keymap.set("n", "<leader>fs", builtin.lsp_document_symbols, { desc = "Symbols in file" })
      vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help" })

      require("telescope").load_extension("ui-select")
    end,
  },
}
