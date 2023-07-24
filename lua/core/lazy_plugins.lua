local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
    -- Color Scheme
    { "catppuccin/nvim",  name = "catppuccin" },
    { "rose-pine/neovim", name = "rose-pine" },
    {
        "bluz71/vim-nightfly-colors",
        name = "nightfly",
        lazy = false,
        priority = 1000,
    },
    {
        "glepnir/zephyr-nvim",
        requires = { "nvim-treesitter/nvim-treesitter", opt = true },
        lazy = false,
        priority = 1000,
    },
    "nvim-tree/nvim-tree.lua",
    {
        "christoomey/vim-tmux-navigator",
        lazy = false,
    },
    "nvim-tree/nvim-web-devicons",
    "nvim-lualine/lualine.nvim",
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
    },
    "windwp/nvim-autopairs",
    "numToStr/Comment.nvim",
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },
    "glepnir/lspsaga.nvim",
    "lewis6991/gitsigns.nvim",
    "akinsho/bufferline.nvim",
    "moll/vim-bbye",
    "akinsho/toggleterm.nvim",
    "lukas-reineke/indent-blankline.nvim",
    "mbbill/undotree",
    "tpope/vim-fugitive",
    "tpope/vim-commentary",
    "theprimeagen/harpoon",
    "windwp/nvim-ts-autotag",
    "MunifTanjim/prettier.nvim",
    {
        "barrett-ruth/live-server.nvim",
        build = "yarn global add live-server",
        config = true,
    },
    {
        "nvim-neorg/neorg",
        build = ":Neorg sync-parsers",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "nvim-cmp",
        },
        cmd = "Neorg",
    },
    {
        "CRAG666/code_runner.nvim",
        config = true,
    },
    {
        "CRAG666/betterTerm.nvim",
        config = true,
    },

    -- LSP Support
    "neovim/nvim-lspconfig",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",

    -- Autocompletion
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "saadparwaiz1/cmp_luasnip",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-nvim-lsp-signature-help",
    "hrsh7th/cmp-nvim-lua",
    "lukas-reineke/cmp-under-comparator",
    {
        "zbirenbaum/copilot-cmp",
        config = function()
            require("copilot_cmp").setup()
        end,
    },
    "onsails/lspkind.nvim",

    -- Snippets
    "L3MON4D3/LuaSnip",
    "rafamadriz/friendly-snippets",
    {
        "creativenull/efmls-configs-nvim",
        tag = "v0.1.3",
        dependencies = { "neovim/nvim-lspconfig" },
    },
    "b0o/schemastore.nvim",
    "mattn/efm-langserver",
    "nvim-lua/plenary.nvim",
    "VidocqH/lsp-lens.nvim",
    {
        "SmiteshP/nvim-navic",
        dependencies = { "neovim/nvim-lspconfig" },
    },

    -- DAP
    "mfussenegger/nvim-dap",
    {
        "rcarriga/nvim-dap-ui",
        dependencies = { "mfussenegger/nvim-dap" },
    },
    {
        "mfussenegger/nvim-dap-python",
        dependencies = {
            "mfussenegger/nvim-dap",
            "rcarriga/nvim-dap-ui",
        },
    },
    -- Telescope
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.0",
        dependencies = { { "nvim-lua/plenary.nvim" } },
    },
    "nvim-telescope/telescope-media-files.nvim",
    "nvim-telescope/telescope-file-browser.nvim",
}
local opts = {
    defaults = {
        lazy = false,
    },
    install = {
        colorscheme = { "nightfly" },
    },
    ui = {
        border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
    },
}
require("lazy").setup(plugins, opts)
