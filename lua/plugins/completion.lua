local M = {
	"saghen/blink.cmp",
	lazy = false,
	dependencies = { "rafamadriz/friendly-snippets" },
	version = "1.*",
	opts_extend = { "sources.default" },

	opts = {
		keymap = {
			preset = "none",

			["<Up>"] = { "select_prev", "fallback" },
			["<Down>"] = { "select_next", "fallback" },
			["<C-CR>"] = { "accept", "fallback" },
			["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
			["<C-e>"] = { "hide", "fallback" },
		},

		appearance = {
			nerd_font_variant = "mono",
		},

		sources = {
			default = { "lsp", "path", "snippets", "buffer" },
		},

		cmdline = { enabled = false },

		signature = {
			enabled = true,
			window = { border = "rounded" },
		},

		completion = {
	    list = { selection = { preselect = true, auto_insert = false } },

			ghost_text = { enabled = true },

			menu = {
				border = "rounded",
				winhighlight = "Normal:None,FloatBorder:None,CursorLine:BlinkCmpMenuSelection,Search:None",
				draw = {
					columns = { { "label", "label_description", gap = 1 } },
				},
			},
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 200,
				window = {
					border = "rounded",
					winhighlight = "Normal:None,FloatBorder:None,CursorLine:BlinkCmpDocCursorLine,Search:None",
				},
			},
		},
	},

	config = function(_, opts)
		local function set_transparent_hl()
			local groups = {
				"BlinkCmpMenu",
				"BlinkCmpMenuBorder",
				"BlinkCmpDoc",
				"BlinkCmpDocBorder",
				"BlinkCmpDocSeparator",
				"BlinkCmpSignatureHelp",
				"BlinkCmpSignatureHelpBorder",
			}
			for _, group in ipairs(groups) do
				vim.api.nvim_set_hl(0, group, { bg = "NONE" })
			end
			-- keep the selected item visible
			vim.api.nvim_set_hl(0, "BlinkCmpMenuSelection", { link = "PmenuSel" })
		end

		set_transparent_hl()

		vim.api.nvim_create_autocmd("ColorScheme", {
			group = vim.api.nvim_create_augroup("BlinkCmpTransparent", { clear = true }),
			callback = set_transparent_hl,
		})

		require("blink.cmp").setup(opts)
	end,
}

return M
