return {
  'ckolkey/ts-node-action',
  config = function()
    require("ts-node-action").setup({
      vim.keymap.set(
        { "n" },
        "<leader>ta",
        require("ts-node-action").node_action,
        { desc = "Trigger Node Action" },
        { noremap = true, silent = true }
      )
    })
  end
}
