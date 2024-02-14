require("catppuccin").setup({
	flavour = "mocha",
	disable_background = true,
})

require("rose-pine").setup({
	variant = "main",
	-- disable_float_background = true,
	disable_background = true,
	groups = {
		error = "love",
		hint = "iris",
		info = "foam",
		warn = "#ea9d34",
	},
	highlight_groups = {
		ColorColumn = { bg = "rose" },
		CursorLine = { bg = "iris", blend = 5 },
	},
})

require("cyberdream").setup({
	transparent = true,
	italic_comments = true,
	hide_fillchars = true,
	borderless_telescope = true,
})

vim.o.termguicolors = true
-- vim.cmd([[colorscheme kanagawa]])
-- vim.cmd([[colorscheme catppuccin]])
-- vim.cmd([[colorscheme PaperColor]])
vim.cmd([[colorscheme cyberdream]])
-- vim.cmd([[colorscheme onedark]])
-- vim.cmd([[colorscheme nightfox]])

vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
