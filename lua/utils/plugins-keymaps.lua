-- Set all plugins keymaps to be used at plugins/whichkey.lua.
local M = {
  -- Git
  { "<leader>g", group = "Git" },
  { "<leader>ga", function() require("gitsigns").diffthis("~") end, desc = "Diff" },
  { "<leader>gb", function() require("gitsigns").blame_line({ full = true }) end, desc = "Blame" },
  { "<leader>gd", "<cmd>Gitsigns toggle_deleted<CR>", desc = "Deleted" },

  -- Utilities
  { "<leader>u", group = "Utilities" },
  { "<leader>ui", "<cmd>LspInfo<cr>", desc = "LSP Info" },
  { "<leader>ul", "<cmd>NullLsInfo<cr>", desc = "NullLs Info" },
  { "<leader>us", "<cmd>SnipInfo<CR>", desc = "Snip Info" },
  { "<leader>um", "<cmd>Noice pick<CR>", desc = "Messages" },
  { "<leader>uc", "<cmd>CsvViewToggle<CR>", desc = "CSV View" },
  { "<leader>up", "<cmd>RenderMarkdown toggle<CR>", desc = "Markdown Preview" },

  -- Managers
  { "<leader>m", group = "Managers" },
  { "<leader>ml", "<cmd>Lazy<CR>", desc = "Lazy Manager" },
  { "<leader>mm", group = "Mason" },
  { "<leader>mml", "<cmd>MasonLog<CR>", desc = "Mason Logs" },
  { "<leader>mmm", "<cmd>Mason<CR>", desc = "Mason Manager" },

  -- Testing
  { "<leader>q", group = "Testing" },
  { "<leader>qd", '<esc><cmd>lua require("neotest").run.run({strategy = "dap"})<CR>', desc = "Debug Nearest" },
  { "<leader>qn", '<esc><cmd>lua require("neotest").run.run()<CR>', desc = "Test Nearest" },
  { "<leader>qf", '<cmd>lua require("neotest").run.run(vim.fn.expand("%"))<CR>', desc = "Test File" },
  { "<leader>qs", '<cmd>lua require("neotest").run.stop()<CR>', desc = "Stop Test" },
  { "<leader>qo", '<cmd>lua require("neotest").output.open()<CR>', desc = "Show Output" },
  { "<leader>qp", '<cmd>lua require("neotest").output_panel.toggle()<CR>', desc = "Show Output" },
  { "<leader>qt", '<cmd>lua require("neotest").summary.toggle()<CR>', desc = "Show Summary" },

  -- Refactor
  { "<leader>r", group = "Refactoring" },
  { "<leader>rs", '<cmd>lua require("spectre").toggle()<CR>', desc = "Toggle Spectre" },
	{ "<leader>ro", '<cmd>lua require("oil").toggle_float()<CR>', desc = "File Refactor" },

  -- Debuging
  { "<leader>d", group = "Debuging" },
  { "<leader>ds", "<cmd>DapContinue<cr>", desc = "Start Debug" },
  { "<leader>db", function() vim.ui.input({ prompt = "Condition: " }, function(input) require("dap").toggle_breakpoint(input) end) end, desc = "Cond. Breakpoint" },
  { "<leader>dc", "<cmd>lua require('telescope').extensions.dap.commands()<cr>", desc = "Commands" },
  { "<leader>dl", "<cmd>lua require('telescope').extensions.dap.list_breakpoints()<cr>", desc = "List Breakpoints" },
  { "<leader>dv", "<cmd>lua require('telescope').extensions.dap.variables()<cr>", desc = "Variables" },
  { "<leader>df", "<cmd>lua require('telescope').extensions.dap.frames()<cr>", desc = "Frames" },
  { "<leader>du", "<cmd>lua require('dapui').toggle()<cr>", desc = "Toggle UI" },

  -- Workspace
  { "<leader>w", group = "Workspace" },
  { "<leader>wh", "<cmd>sp<CR>", desc = "Add Horizontal Window" },
  { "<leader>wv", "<cmd>vsp<CR>", desc = "Add Vertical Window" },
  { "<leader>wl", "<cmd>set wrap!<CR>", desc = "Toggle Line Wrap" },
  { "<leader>wm", "<cmd>lua require('mini.map').toggle()<CR>", desc = "MiniMap" },
}

return M
