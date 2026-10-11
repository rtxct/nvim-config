local M = {
	plugins = {
		"java-test",
		"java-debug-adapter",

		"shfmt",
		"stylua",

		"google-java-format",

		"prettierd",
		"prettier",

		"yamlfmt",
		"sql-formatter",
		"djlint",
		"eslint_d",
	},

	lsp = {
		"lua_ls",
		"bashls",

		"html",
		"cssls",
		"cssmodules_ls",

		"ts_ls",
		"jdtls",
		"ruff",
		"pyright",

		"qmlls",
		"jsonls",
		"yamlls",

		"dockerls",
		"docker_compose_language_service",
	},
}

return M
