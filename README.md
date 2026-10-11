### Overview

A modular Neovim configuration built around Lazy.nvim, with support for LSP, DAP, testing, formatting, and multiple programming languages.

<br>

<div align="center">
 <img src="./content/demo.gif" alt="demo">
</div>

<br>

### Contents

- **init.lua** — Entrypoint that sets runtime paths, loads the core configuration modules, and initializes Lazy.nvim.
- **ftplugin/** — Dedicated setups for complex languages (e.g. Java via `nvim-jdtls`), isolating workspace roots and heavy language tools from the global LSP loop.
- **setup.sh** — Interactive installer that safely backs up your current Neovim setup, copies over the files, and optionally cleans caches for a fresh start.
- **lazy-lock.json** — Lockfile pinning verified versions of all installed plugins.
- **lua/** — Modular configuration tree:
  - **lazy.lua** — Bootstraps `lazy.nvim` with custom UI styling and performance caching.
  - **core/** — Core editor settings, general navigation, and direct key bindings (`keymaps.lua`, `options.lua`, `plugin-keymaps.lua`).
  - **plugins/** — Self-contained plugin specifications (Git, Treesitter, UI, Testing, etc.):
    - **dap/** — Modular debugging setup, with individual language adapter configurations under `dap/settings/`.
    - **lsp/** — Language server setup, diagnostic styles, and per-server customizations in `lsp/settings/`.
  - **themes/** — Colorscheme and appearance settings (like the minimalist `monochrome.lua` with transparent float support).
  - **utils/** — Centralized tables for Mason packages, Treesitter parsers, and Which-Key menu structures.
  - **vim/** — Native autocommands and custom user commands.

### Quick Summary

The idea is to provide a clean and generic Neovim configuration that’s easy to maintain and adapt. While it already includes optimized setups for Java, it’s structured to make it simple to add or adjust support for any language.

Languages, as well as Linters and Formatters, are automatically installed through Mason. To add a new language, you usually just need to append the server's name to [lua/utils/mason-ensure-installed.lua](https://github.com/rafaeltxc/Neovim/blob/master/lua/utils/mason-ensure-installed.lua) and its syntax parser in [lua/utils/treesitter-ensure-installed.lua](https://github.com/rafaeltxc/Neovim/blob/master/lua/utils/treesitter-ensure-installed.lua).

- **Formatting & Linting:** Handled cleanly without LSP conflicts. [conform.nvim](https://github.com/stevearc/conform.nvim) handles code formatting (triggered via `<F5>`), while [nvim-lint](https://github.com/mfussenegger/nvim-lint) takes care of linters like ESLint and Ruff. LSP formatting is explicitly turned off so tools never fight over your code.
- **Completion:** Powered by the blazingly fast [blink.cmp](https://github.com/Saghen/blink.cmp), giving you instant fuzzy completions and snippet integration without slowing down large files.
- **Testing:** Out-of-the-box support for Java, JS/TS, and Python via [neotest](https://github.com/nvim-neotest/neotest). Extra language adapters can be dropped straight into [lua/plugins/neotest.lua](https://github.com/rafaeltxc/Neovim/blob/master/lua/plugins/neotest.lua).
- **Debugging:** Configured with [nvim-dap](https://github.com/mfussenegger/nvim-dap) and `nvim-dap-ui`. Adapter configurations are modularized inside `lua/plugins/dap/settings/<language>.lua`, complete with dynamic port prompts when attaching to running processes.

### Keymaps

Keymaps are organized into three distinct places depending on how they are accessed:

- **[lua/core/keymaps.lua](https://github.com/rafaeltxc/Neovim/blob/master/lua/core/keymaps.lua):** Standard Neovim motions, window splits, buffer cycling, and line moving.
- **[lua/core/plugin-keymaps.lua](https://github.com/rafaeltxc/Neovim/blob/master/lua/core/plugin-keymaps.lua):** Direct function shortcuts you use every day without a leader key (such as `<F5>` for formatting, `<S-Esc>` for the file explorer, and function keys for diagnostics/renaming).
- **[lua/utils/plugins-keymaps.lua](https://github.com/rafaeltxc/Neovim/blob/master/lua/utils/plugins-keymaps.lua):** Grouped actions triggered via `<leader>` and visually presented through [which-key.nvim](https://github.com/folke/which-key.nvim) (like Git, Tests, Refactoring, and Debug commands).

Some specialized keymaps can also be found directly within their individual plugin files, such as [multicursor](https://github.com/rafaeltxc/Neovim/blob/master/lua/plugins/multicursor.lua).

---

### Installation

Clone the repo:
```bash
git clone https://github.com/rtxct/nvim-config.git
cd nvim-config
```

Run the interactive setup script:
```bash
# Make sure setup.sh is executable:
chmod +x ./setup.sh

# Run the installer:
./setup.sh
```

Then open Neovim:
```bash
nvim
```

Lazy.nvim will automatically download and set up plugins, while Mason ensures your configured language servers and formatters are ready. This might take a minute or two on the first run. Once done, restarting Neovim is recommended so all updates take full effect.

### Support

This configuration was written for Linux (tested on Arch specifically), and should work fine on most distributions. Although it includes default handling for other operating systems, some adjustments may be required since macOS and Windows have their own quirks. Setting it up is generally pretty straightforward—mostly adjusting system paths or tool names to match your environment.

### Contributing and Repository Activity

This is only my personal take on Neovim that i've been working on a while from time to time, and as it's just a hobby, i wont be going to work on it all the times, but i do intend to keep improving it. The ideia that will follow the subsequent improvements is to make the configuration feel even more like an actual IDE.
 
- Plugins improvements
    - The addition of new plugins is not guaranteed to happen, at least not plugins that change the current looks and/or mechanics, such as _bufferline.nvim_ or _lualine.nvim_. On the other hand, plugins such as _harpoon.nvim_ might be added since their use is more “optional” and up to each individual user.
 
I won’t be writing a _CONTRIBUTING.md_, since the project is pretty simple, but any contribution is welcome as long as it follows the notes above.

As far as code formatting goes, just stick to the current file style while using stylua with its default settings and it should be enough.
