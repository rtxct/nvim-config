return {
	configurations = {
		{
			name = "Debug Launch (2GB)",
			type = "java",
			request = "launch",
			vmArgs = "-Xmx2g ",
		},
		{
			name = "Debug Attach (Dynamic Port)",
			type = "java",
			request = "attach",
			hostName = "127.0.0.1",
			port = function()
				local val = vim.fn.input("Port: ")
				assert(val ~= "", "Please provide a port number")
				return tonumber(val)
			end,
		},
	},
}
