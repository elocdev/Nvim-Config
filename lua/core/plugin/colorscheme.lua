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

vim.o.termguicolors = true
vim.cmd([[colorscheme nightfly]])

vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
