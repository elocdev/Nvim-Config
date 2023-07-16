local path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
require("dapui").setup()
require("dap-python").setup(path)

local keymap = vim.keymap.set
local dap, dapui = require("dap"), require("dapui")

dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close()
end
keymap("n", "<leader>dt", ":DapToggleBreakpoint<CR>")
keymap("n", "<leader>dx", ":DapTerminate<CR>")
keymap("n", "<leader>do", ":DapStepOver<CR>")
keymap("n", "<leader>dpr", "<cmd>lua require('dap-python').test_method()<CR>")
keymap("n", "<leader>dc", "<cmd>lua require('dap-python').close()<CR>")
