local keymap = vim.keymap.set

keymap("n", "<leader>gs", vim.cmd.Git)
keymap("n", "<leader>t", ":Git push origin master<CR>", opts)
keymap("n", "<leader>P", ":Git pull origin <CR>", opts)
