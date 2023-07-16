require("neorg").setup({
	load = {
		["core.defaults"] = {}, -- Loads default behaviour
		["core.completion"] = { config = { engine = "nvim-cmp", name = "[Norg]" } },
		["core.integrations.nvim-cmp"] = {},
		["core.concealer"] = { config = { icon_preset = "diamond" } }, -- Adds pretty icons to your documents
		["core.export"] = {},
		["core.dirman"] = { -- Manages Neorg workspaces
			config = {
				workspaces = {
					work = "~/ProprioOneDrive/Automation",
				},
			},
		},
	},
})
