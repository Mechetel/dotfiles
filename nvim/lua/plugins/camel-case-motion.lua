return {
  'bkad/CamelCaseMotion',
  config = function()
    local opts = { silent = true, noremap = false }

    -- CamelCaseMotion mappings
    vim.keymap.set("", "w", "<Plug>CamelCaseMotion_w", opts)
    vim.keymap.set("", "b", "<Plug>CamelCaseMotion_b", opts)
    vim.keymap.set("", "e", "<Plug>CamelCaseMotion_e", opts)
    vim.keymap.set("", "ge", "<Plug>CamelCaseMotion_ge", opts)

    -- Remove the mappings in select mode (sunmap in Vimscript)
    vim.api.nvim_del_keymap("s", "w")
    vim.api.nvim_del_keymap("s", "b")
    vim.api.nvim_del_keymap("s", "e")
    vim.api.nvim_del_keymap("s", "ge")
  end,
}
