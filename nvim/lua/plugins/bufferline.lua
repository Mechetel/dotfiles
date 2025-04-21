return {
	"akinsho/bufferline.nvim",
	version = "*",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("bufferline").setup({
			highlights = require("catppuccin.groups.integrations.bufferline").get({
        styles = { "italic", "bold" },
        custom = {
          all = {
            fill = { bg = "#171825" },
          },
        },
      }),
			options = {
				buffer_close_icon = "", -- Icon to close a buffer
				close_command = "bdelete! %d", -- Command to close a buffer
				left_mouse_command = "buffer %d", -- Left-click to navigate to buffer
				indicator = {
					icon = "▎", -- Customize the indicator icon
					style = "icon",
				},
				tab_size = 18,
				diagnostics = "nvim_lsp",
				diagnostics_indicator = function(count, level, diagnostics_dict, context)
					local s = " "
					for e, n in pairs(diagnostics_dict) do
						local sym = e == "error" and " " or (e == "warning" and " " or " ")
						s = s .. n .. sym
					end
					return s
				end,
				always_show_bufferline = true,
				show_buffer_icons = true,
				show_buffer_close_icons = true,
				show_close_icon = true,
				show_tab_indicators = true,
				persist_buffer_sort = true,
				separator_style = "thick",
				enforce_regular_tabs = false,
				offsets = { { filetype = "neo-tree", text = "Neo-tree", padding = 0, text_align = "left" } },
			},
		})
	end,
}
