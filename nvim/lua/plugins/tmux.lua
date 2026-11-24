local plugins = {
  { "christoomey/vim-tmux-navigator" },
}

if vim.env.TMUX ~= nil and vim.env.TMUX ~= "" then
  vim.list_extend(plugins, {
    { "tmux-plugins/vim-tmux" },
    { "wellle/tmux-complete.vim" },
    {
      "benmills/vimux",
      config = function()
        vim.g.VimuxRunnerType = "window"
        vim.g.VimuxUseNearest = 0

        vim.keymap.set("n", "<leader>tt", ":VimuxTogglePane<CR>", { silent = true })
        vim.keymap.set("n", "<leader>to", ":call VimuxOpenRunner()<CR>", { silent = true })
        vim.keymap.set("n", "<leader>tl", ":VimuxRunLastCommand<CR>", { silent = true })

        -- Run tests of the current file in the tmux runner pane.
        --   <leader>ts  whole test file       <leader>tr  nearest test (file:line)
        -- From app/models/user.rb it picks spec/models/user_spec.rb (RSpec) or
        -- test/models/user_test.rb (Minitest), whichever the project uses.
        local function test_target()
          local root = vim.fs.root(0, { "Gemfile", ".git" }) or vim.fn.getcwd()
          local rel = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":p"):sub(#root + 2)
          if rel:match("_spec%.rb$") or rel:match("_test%.rb$") then
            return root, rel
          end
          local alt = rel:gsub("^app/", ""):gsub("^lib/", ""):gsub("%.rb$", "")
          for _, c in ipairs({ "spec/" .. alt .. "_spec.rb", "test/" .. alt .. "_test.rb" }) do
            if vim.uv.fs_stat(root .. "/" .. c) then
              return root, c
            end
          end
          return root, nil
        end

        local function run_tests(with_line)
          local root, file = test_target()
          if not file then
            vim.notify("No matching spec/test file for this buffer", vim.log.levels.WARN)
            return
          end
          local target = file
          if with_line and (file:match("_spec%.rb$") or file:match("_test%.rb$")) and vim.fn.expand("%:p") == root .. "/" .. file then
            target = file .. ":" .. vim.fn.line(".")
          end
          local runner
          if file:match("_spec%.rb$") then
            runner = vim.uv.fs_stat(root .. "/bin/rspec") and "bin/rspec" or "bundle exec rspec"
          else
            runner = "bin/rails test"
          end
          vim.fn.VimuxRunCommand("cd " .. vim.fn.shellescape(root) .. " && " .. runner .. " " .. target)
        end

        vim.keymap.set("n", "<leader>ts", function() run_tests(false) end, { silent = true, desc = "Run test file" })
        vim.keymap.set("n", "<leader>tr", function() run_tests(true) end, { silent = true, desc = "Run nearest test" })

        vim.api.nvim_create_autocmd("VimEnter", {
          pattern = "*",
          callback = function()
            vim.fn.system("tmux source ~/.dotfiles/tmux/themes/dracula_tmuxline_new.conf")
          end,
        })

        vim.api.nvim_create_autocmd("VimLeave", {
          pattern = "*",
          callback = function()
            vim.fn.system("tmux source ~/.dotfiles/tmux/themes/dracula_tmuxline_new.conf")
          end,
        })
      end
    },
    {
      "edkolev/tmuxline.vim",
      config = function()
        vim.g.tmuxline_theme = "dracula"
        vim.g.tmuxline_preset = "minimal"
      end
    }
  })
end

return plugins
