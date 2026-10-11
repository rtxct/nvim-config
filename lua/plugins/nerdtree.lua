local M = {
	"nvim-tree/nvim-tree.lua",
	lazy = false,
	opts = {
		disable_netrw = true,
		hijack_netrw = true,

		view = {
			width = "100%",
		},

		renderer = {
			icons = {
				show = { file = false, folder = false, folder_arrow = true, git = true },
			},
		},

		filters = {
			dotfiles = true,
			custom = { "^node_modules$" },
		},

		actions = {
			open_file = { quit_on_open = true },
		},

		update_focused_file = {
			enable = true,
			update_root = false,
		},

		on_attach = function(bufnr)
			local api = require("nvim-tree.api")
			api.config.mappings.default_on_attach(bufnr)
			vim.keymap.set("n", "q", api.tree.close, { buffer = bufnr, noremap = true, silent = true })
		end,
	},
}

return M
