local M = {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	opts = {
		formatters_by_ft = {
			sh = { "shfmt" },
			lua = { "stylua" },

			python = { "ruff_format" },

			javascript = { "prettierd", "prettier", stop_after_first = true },
			typescript = { "prettierd", "prettier", stop_after_first = true },

			javascriptreact = { "prettierd", "prettier", stop_after_first = true },
			typescriptreact = { "prettierd", "prettier", stop_after_first = true },

			json = { "prettierd", "prettier", stop_after_first = true },
			html = { "prettierd", "prettier", stop_after_first = true },

			css = { "prettierd", "prettier", stop_after_first = true },

			java = { "google-java-format" },

			yaml = { "yamlfmt" },
			sql = { "sql_formatter" },
			htmldjango = { "djlint" },
		},
		formatters = {
			["google-java-format"] = {
				range_args = function(self, ctx)
					return {
						"--lines",
						string.format("%d:%d", ctx.range.start[1], ctx.range["end"][1]),
						"-",
					}
				end,
			},
		},
	},
}

return M
