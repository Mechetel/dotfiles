return {
  "mhinz/vim-startify",
  config = function()
    local cache_dir = vim.fn.expand("~/.config/nvim/.cache")
    local function get_cache_dir(suffix)
      return vim.fn.resolve(cache_dir .. "/" .. suffix)
    end

    vim.g.startify_session_dir = get_cache_dir("sessions")
    vim.g.startify_change_to_vcs_root = 1
    vim.g.startify_show_sessions = 1
    vim.g.startify_session_before_save = { "tabdo NERDTreeClose" }
    vim.g.startify_disable_at_vimenter = 1

    vim.api.nvim_create_autocmd("VimEnter", {
      pattern = "*",
      nested = true,
      callback = function()
        if vim.fn.argc() == 0 then
          local cwd_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
          vim.cmd("silent! SLoad " .. cwd_name)
          vim.cmd("redraw!")
        end
      end,
    })

    vim.keymap.set("n", "<leader>S", function()
      local cwd_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
      vim.cmd("SSave " .. cwd_name)
    end, { silent = true, noremap = true })
  end,
}
