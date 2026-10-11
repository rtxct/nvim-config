local M = {
  "mfussenegger/nvim-dap",
  event = "VeryLazy",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "rcarriga/nvim-dap-ui",
    "theHamsta/nvim-dap-virtual-text",
  },
  opts = {
    ui = {
      auto_open = true,
      auto_close = true,
      floating = {
        border = "rounded",
        mappings = { close = { "q", "<Esc>" } },
      },
    },
  },
  config = function(_, opts)
    local dap = require("dap")
    local dapui = require("dapui")
    local dapvt = require("nvim-dap-virtual-text")

    -- Helper function to place a sign in a safe, future-proof way
    local function place_sign(name, line, bufnr)
      vim.fn.sign_place(0, "", name, bufnr or 0, { lnum = line, priority = 10 })
    end

    -- Hook into DAP events to place/update signs
    dap.listeners.after.event_initialized["dapui_config"] = function()
      if opts.ui.auto_open then
        dapui.open()
      end
    end

    dap.listeners.before.event_terminated["dapui_config"] = function()
      if opts.ui.auto_close then
        dapui.close()
      end
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      if opts.ui.auto_close then
        dapui.close()
      end
    end

    -- Keymaps
    local map = vim.keymap.set
    local silent = { silent = true }
    map("n", "<F9>", dap.continue, silent)
    map("n", "<F8>", dap.step_over, silent)
    map("n", "<F7>", dap.step_into, silent)
    map("n", "<F12>", dap.step_out, silent)

    -- Highlights
    vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#FF0000" })
    vim.api.nvim_set_hl(0, "DapStopped", { fg = "#FFFF00" })

    -- DAP signs
    vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticSignError", linehl = "", numhl = "" })
    vim.fn.sign_define(
      "DapBreakpointCondition",
      { text = "", texthl = "DiagnosticSignWarn", linehl = "", numhl = "" }
    )
    vim.fn.sign_define(
      "DapBreakpointRejected",
      { text = "", texthl = "DiagnosticSignError", linehl = "", numhl = "" }
    )
    vim.fn.sign_define("DapLogPoint", { text = "", texthl = "DiagnosticSignInfo", linehl = "", numhl = "" })
    vim.fn.sign_define("DapStopped", { text = "➜", texthl = "DapStopped", linehl = "Visual", numhl = "" })

    -- Virtual text setup
    dapvt.setup({
      enabled = true,
      commented = false,
      virt_text_pos = "eol",
    })

    -- DAP UI setup
    dapui.setup({
      floating = opts.ui.floating,
      controls = { enabled = true, element = "repl" },
      layouts = {
        { elements = { "scopes", "breakpoints", "stacks", "watches" }, size = 0.33, position = "left" },
        { elements = { "repl", "console" },                            size = 0.27, position = "bottom" },
      },
    })

    -- Dynamically load language configurations from plugins/dap/settings
    local dap_settings_path = vim.fn.stdpath("config") .. "/lua/plugins/dap/settings"
    if vim.fn.isdirectory(dap_settings_path) == 1 then
      for _, file in ipairs(vim.fn.readdir(dap_settings_path)) do
        if file:match("%.lua$") then
          local lang = file:gsub("%.lua$", "")
          local ok, config = pcall(require, "plugins.dap.settings." .. lang)
          if ok and type(config) == "table" then
            if config.adapters then
              dap.adapters[lang] = config.adapters
            end
            if config.configurations then
              dap.configurations[lang] = config.configurations
            end
          end
        end
      end
    end
  end,
}

return M
