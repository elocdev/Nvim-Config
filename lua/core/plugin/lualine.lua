local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
	return
end

local navic = require("nvim-navic")

local hide_in_width = function()
	return vim.fn.winwidth(0) > 80
end

local diagnostics = {
	"diagnostics",
	sources = { "nvim_diagnostic" },
	sections = { "error", "warn" },
	symbols = { error = " ", warn = " " },
	colored = false,
	update_in_insert = false,
	always_visible = true,
}

local diff = {
	"diff",
	colored = false,
	symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
	cond = hide_in_width,
}

local filetype = {
	"filetype",
	icons_enabled = false,
	icon = nil,
}

lualine.setup({
	options = {
		icons_enabled = true,
		theme = "cyberdream",
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		disabled_filetypes = { "dashboard", "NvimTree", "Outline" },
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch" },
		lualine_c = { {
			"filename",
			file_status = true,
			path = 0,
		} },
		lualine_x = { diagnostics, diff, "encoding", filetype },
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { {
			"filename",
			file_status = true,
			path = 1,
		} },
		lualine_x = { "location" },
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {},
	extensions = { "fugitive" },
	winbar = {
		lualine_c = {
			{
				function()
					return navic.get_location()
				end,
				cond = function()
					return navic.is_available()
				end,
			},
		},
	},
})
