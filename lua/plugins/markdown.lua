local M = {
	"MeanderingProgrammer/render-markdown.nvim",
  lazy = false,
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	---@module 'render-markdown'
	---@type render.md.UserConfig
	opts = {
		anti_conceal = {
			enabled = true,
			disabled_modes = false,
			above = 0,
			below = 0,

			ignore = {
				code_background = true,
				indent = true,
				sign = true,
				virtual_lines = true,
			},
		},
	},

	config = function(_, opts)
		require("render-markdown").setup(opts)
	end,
}

return M

