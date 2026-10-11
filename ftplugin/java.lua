local status_ok, jdtls = pcall(require, "jdtls")
if not status_ok then
	return
end

local system = vim.loop.os_uname().sysname
local CONFIG
if system == "Linux" then
	CONFIG = "config_linux"
elseif system == "Darwin" then
	CONFIG = "config_mac"
else
	CONFIG = "config_win"
end

local HOME = vim.fn.expand("$HOME")
local MASON = HOME .. "/.local/share/nvim/mason"
local JDTLS_PATH = MASON .. "/packages/jdtls"
local LOMBOK = MASON .. "/share/jdtls/lombok.jar"

local launcher_path = vim.fn.glob(JDTLS_PATH .. "/plugins/org.eclipse.equinox.launcher_*.jar")

local bundles = {
	vim.fn.glob(MASON .. "/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar", 1),
}
vim.list_extend(bundles, vim.split(vim.fn.glob(MASON .. "/packages/java-test/extension/server/*.jar", 1), "\n"))

-- Unique workspace dir per project
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = HOME .. "/.cache/jdtls/workspace/" .. project_name

local config = {
	cmd = {
		-- Use the default java (e.g. Java 21) to RUN the server
		"java",
		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
		"-Dosgi.bundles.defaultStartLevel=4",
		"-Declipse.product=org.eclipse.jdt.ls.core.product",
		"-Dlog.protocol=true",
		"-Dlog.level=ALL",
		"-Xmx1g",
		"--add-modules=ALL-SYSTEM",
		"--add-opens",
		"java.base/java.util=ALL-UNNAMED",
		"--add-opens",
		"java.base/java.lang=ALL-UNNAMED",
		"-javaagent:" .. LOMBOK,
		"-jar",
		launcher_path,
		"-configuration",
		JDTLS_PATH .. "/" .. CONFIG,
		"-data",
		workspace_dir,
	},
	-- Root dir is evaluated per-buffer now!
	root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }),
	init_options = {
		bundles = bundles,
	},
	settings = {
		java = {
			eclipse = {
				downloadSources = true,
			},
			configuration = {
				updateBuildConfiguration = "interactive",
				runtimes = (function()
					if system == "Darwin" then
						return {
							{ name = "JavaSE-1.8", path = "/Library/Java/JavaVirtualMachines/openjdk-8.jdk/Contents/Home" },
							{ name = "JavaSE-11", path = "/Library/Java/JavaVirtualMachines/openjdk-11.jdk/Contents/Home" },
							{ name = "JavaSE-17", path = "/Library/Java/JavaVirtualMachines/openjdk-17.jdk/Contents/Home" },
							{ name = "JavaSE-21", path = "/Library/Java/JavaVirtualMachines/openjdk-21.jdk/Contents/Home", default = true },
						}
					elseif system == "Linux" then
						return {
							{ name = "JavaSE-1.8", path = "/usr/lib/jvm/java-8-openjdk-amd64" },
							{ name = "JavaSE-11", path = "/usr/lib/jvm/java-11-openjdk" },
							{ name = "JavaSE-17", path = "/usr/lib/jvm/java-17-openjdk" },
							{ name = "JavaSE-21", path = "/usr/lib/jvm/java-21-openjdk", default = true },
						}
					else
						return {}
					end
				end)(),
			},
			maven = {
				downloadSources = true,
			},
			implementationsCodeLens = {
				enabled = true,
			},
			referencesCodeLens = {
				enabled = true,
			},
			references = {
				includeDecompiledSources = true,
			},
		},
	},
}

-- Attach DAP when JDTLS attaches
config.on_attach = function(client, bufnr)
	jdtls.setup_dap({ hotcodereplace = "auto" })
	require("jdtls.dap").setup_dap_main_class_configs()
end

jdtls.start_or_attach(config)
