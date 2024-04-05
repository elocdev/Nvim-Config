require("catppuccin").setup({
	flavour = "mocha",
	disable_background = true,
	integrations = {
		neotest = true,
		mason = true,
	},
})

require("cyberdream").setup({
	transparent = true,
	italic_comments = true,
	hide_fillchars = true,
	borderless_telescope = true,
})

vim.o.termguicolors = true
-- vim.cmd([[colorscheme catppuccin]])
-- vim.cmd([[colorscheme PaperColor]])
vim.cmd([[colorscheme cyberdream]])
-- vim.cmd([[colorscheme onedark]])
-- vim.cmd([[colorscheme carbonfox]])

vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
