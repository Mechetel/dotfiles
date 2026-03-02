return {
  "slim-template/vim-slim",
  config = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "slim",
      callback = function()
        vim.bo.shiftwidth = 2
        vim.bo.tabstop = 2
        vim.bo.softtabstop = 2
        vim.bo.expandtab = true
      end,
    })
  end,
}
