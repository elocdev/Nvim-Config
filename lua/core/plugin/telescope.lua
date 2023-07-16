local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
	return
end
local builtin = require("telescope.builtin")
local actions = require("telescope.actions")
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

local function telescope_buffer_dir()
	return vim.fn.expand("%:p:h")
end

local fb_actions = require("telescope").extensions.file_browser.actions
telescope.load_extension("media_files")

telescope.setup({
	defaults = {
		path_display = { "smart" },

		mappings = {
			i = {
				["<C-j>"] = actions.move_selection_next,
				["<C-k>"] = actions.move_selection_previous,

				["<C-c>"] = actions.close,

				["<Down>"] = actions.move_selection_next,
				["<Up>"] = actions.move_selection_previous,

				["<CR>"] = actions.select_default,
				["<C-x>"] = actions.select_horizontal,
				["<C-v>"] = actions.select_vertical,
				["<C-t>"] = actions.select_tab,

				["<C-l>"] = actions.complete_tag,
				["<C-_>"] = actions.which_key, -- keys from pressing <C-/>
			},

			n = {
				["q"] = actions.close,
				["<CR>"] = actions.select_default,
				["<C-x>"] = actions.select_horizontal,
				["<C-v>"] = actions.select_vertical,
				["<C-t>"] = actions.select_tab,

				["j"] = actions.move_selection_next,
				["k"] = actions.move_selection_previous,
				["H"] = actions.move_to_top,
				["M"] = actions.move_to_middle,
				["L"] = actions.move_to_bottom,

				["<Down>"] = actions.move_selection_next,
				["<Up>"] = actions.move_selection_previous,
				["gg"] = actions.move_to_top,
				["G"] = actions.move_to_bottom,

				["?"] = actions.which_key,
			},
		},
	},
	extensions = {
		media_files = {
			-- defaults to {"png", "jpg", "mp4", "webm", "pdf"}
			filetypes = { "png", "webp", "jpg", "jpeg" },
			find_cmd = "rg", -- find command (defaults to `fd`)
		},
		file_browser = {
			theme = "dropdown",
			-- disables netrw and use telescope-file-browser in its place
			hijack_netrw = true,
			mappings = {
				-- your custom insert mode mappings
				["i"] = {
					["<C-w>"] = function()
						vim.cmd("normal vbd")
					end,
				},
				["n"] = {
					-- your custom normal mode mappings
					["N"] = fb_actions.create,
					["h"] = fb_actions.goto_parent_dir,
					["D"] = fb_actions.remove,
					["/"] = function()
						vim.cmd("startinsert")
					end,
				},
			},
		},
	},
})

telescope.load_extension("file_browser")

vim.keymap.set("n", "sd", function()
	telescope.extensions.file_browser.file_browser({
		path = "%:p:h",
		cwd = telescope_buffer_dir(),
		respect_gitignore = false,
		hidden = true,
		grouped = true,
		previewer = false,
		initial_mode = "normal",
		layout_config = { height = 40 },
	})
end)

keymap(
	"n",
	"<leader>pf",
	"<cmd>lua require'telescope.builtin'.find_files(require('telescope.themes').get_dropdown({ previewer = false }))<CR>",
	opts
)
keymap(
	"n",
	"<C-p>",
	"<cmd>lua require'telescope.builtin'.git_files(require('telescope.themes').get_dropdown({ previewer = false }))<CR>",
	opts
)
keymap(
	"n",
	"<leader>ps",
	"<cmd>lua require'telescope.builtin'.grep_string({ search = vim.fn.input('Grep > ') })<CR>",
	opts
)
