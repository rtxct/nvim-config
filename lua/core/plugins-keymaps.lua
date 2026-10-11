local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

local modes = { "n", "i", "v" }

-- File Explorer
keymap(modes, "<S-Esc>", "<cmd>NvimTreeToggle<CR>", opts)

-- LSP
keymap(modes, "<S-Del>", function()
	vim.diagnostic.open_float()
end, opts)

keymap(modes, "<C-m>", function()
	vim.lsp.buf.definition()
end, opts)

keymap(modes, "<C-j>", function()
	vim.lsp.buf.declaration()
end, opts)

keymap(modes, "<C-i>", function()
	vim.lsp.buf.implementation()
end, opts)

keymap(modes, "<C-k>", function()
	vim.lsp.buf.hover()
end, opts)

keymap(modes, "<C-y>", function()
	require("trouble").toggle("lsp_references")
end, opts)

keymap(modes, "<F6>", function()
	vim.lsp.buf.rename()
end, opts)

keymap(modes, "<F4>", function()
	vim.lsp.buf.code_action()
end, opts)

-- Diagnostics
keymap(modes, "<F1>", function()
	vim.diagnostic.jump({ count = 1, bufnr = 0 })
end, opts)

keymap(modes, "<F2>", function()
	vim.diagnostic.jump({ count = -1, bufnr = 0 })
end, opts)

keymap(modes, "<F3>", "<cmd>Trouble diagnostics<cr>", opts)

-- Telescope
keymap(modes, "<S-f>", "<cmd>Telescope live_grep<cr>", opts)
keymap(modes, "<C-f>", "<cmd>Telescope find_files<cr>", opts)

-- Format code
keymap({ "n", "i" }, "<F5>", function()
	require("conform").format({ async = true, lsp_format = "never" })
end, opts)

keymap("v", "<F5>", function()
	local l1 = vim.fn.getpos("v")[2]
	local l2 = vim.fn.getpos(".")[2]
	if l1 > l2 then
		l1, l2 = l2, l1
	end
	local last_line = vim.api.nvim_buf_get_lines(0, l2 - 1, l2, true)[1]

	-- leave visual mode, then format only the selected lines
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
	require("conform").format({
		async = true,
		lsp_format = "never",
		range = { start = { l1, 0 }, ["end"] = { l2, #last_line } },
	})
end, opts)

-- SnipRun
keymap("v", "x", "<Plug>SnipRun", opts)

-- Debugging
keymap(modes, "<C-b>", "<cmd>DapToggleBreakpoint<cr>", opts)
