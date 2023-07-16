-- Line Numbers
vim.opt.nu = true
vim.opt.relativenumber = true

-- Tabbing
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.mouse = "a"

vim.opt.wrap = false
vim.opt.scrolloff = 8

vim.opt.updatetime = 50
vim.opt.smartcase = true
vim.opt.pumheight = 10
vim.opt.ignorecase = true
vim.opt.completeopt = { "menuone", "noselect" }

vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true
vim.opt.conceallevel = 2
vim.opt.foldlevel = 99

vim.api.nvim_create_autocmd("BufEnter", { command = ":TSEnable highlight" })

vim.api.nvim_create_augroup("highlight", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter" }, {
	group = "highlight",
	pattern = { "*.py" },
	callback = function()
		vim.cmd(":TSEnable highlight")
	end,
})
