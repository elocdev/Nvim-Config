local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok then
	return
end

local servers = {
	"lua_ls",
	"pyright",
	"jsonls",
	"tsserver",
	"eslint",
	"tailwindcss",
	"cssls",
}

local settings = {
	ui = {
		border = "none",
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗",
		},
	},
	log_level = vim.log.levels.INFO,
	automatic_installation = true,
}

local signs = {
	{ name = "DiagnosticSignError", text = " " },
	{ name = "DiagnosticSignWarn", text = " " },
	{ name = "DiagnosticSignHint", text = "" },
	{ name = "DiagnosticSignInfo", text = " " },
}
for _, sign in ipairs(signs) do
	vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
end

local config = {
	-- disable virtual text
	virtual_text = {
		-- Only display errors w/ virtual text
		severity = { vim.diagnostic.severity.ERROR },
		-- Prepend with diagnostic source if there is more than one attached to the buffer
		-- (e.g. (eslint) Error: blah blah blah)
		source = "if_many",
		signs = true,
	},
	-- show signs
	signs = {
		active = signs,
	},
	update_in_insert = true,
	severity_sort = true,
	float = {
		severity_sort = true,
		style = "minimal",
		source = "always",
		border = "roundedd",
		header = {
			"",
			"LspDiagnosticsDefaultWarning",
		},
		prefix = function(diagnostic)
			local diag_to_format = {
				[vim.diagnostic.severity.ERROR] = { "Error", "LspDiagnosticsDefaultError" },
				[vim.diagnostic.severity.WARN] = { "Warning", "LspDiagnosticsDefaultWarning" },
				[vim.diagnostic.severity.INFO] = { "Info", "LspDiagnosticsDefaultInfo" },
				[vim.diagnostic.severity.HINT] = { "Hint", "LspDiagnosticsDefaultHint" },
			}
			local res = diag_to_format[diagnostic.severity]
			return string.format("(%s) ", res[1]), res[2]
		end,
	},
}

vim.diagnostic.config(config)

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
	border = "rounded",
})

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
	border = "rounded",
})

local function lsp_highlight_document(client)
	-- Set autocommands conditional on server_capabilities
	if client.server_capabilities.documentHighlight then
		vim.api.nvim_exec(
			[[
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END,,
    ]],
			false
		)
	end
end

require("mason").setup(settings)
require("mason-lspconfig").setup({
	ensure_installed = servers,
	automatic_installation = true,
})

local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()
local lsp_attach = function(client, bufnr)
	local opts = { buffer = bufnr, remap = false, silent = true }
	vim.keymap.set("n", "gd", function()
		vim.lsp.buf.definition()
	end, opts)
	vim.keymap.set("n", "<leader>gi", function()
		vim.lsp.buf.implementation()
	end, opts)
	vim.keymap.set("n", "<leader>vd", function()
		vim.diagnostic.open_float()
	end, opts)
	vim.keymap.set("n", "dn", function()
		vim.diagnostic.goto_next()
	end, opts)
	vim.keymap.set("n", "dp", function()
		vim.diagnostic.goto_prev()
	end, opts)
	vim.keymap.set("n", "<leader>ca", function()
		vim.lsp.buf.code_action()
	end, opts)
	vim.keymap.set("n", "<leader>gr", function()
		vim.lsp.buf.references()
	end, opts)
	vim.keymap.set("n", "<leader>rn", function()
		vim.lsp.buf.rename()
	end, opts)
	vim.keymap.set("n", "<leader>he", function()
		vim.lsp.buf.signature_help()
	end, opts)

	if client.name == "tsserver" then
		client.server_capabilities.documentFormattingProvider = false
	end
	lsp_highlight_document(client)
end

local opts = {}
local get_servers = require("mason-lspconfig").get_installed_servers

for _, server_name in pairs(get_servers()) do
	opts = {
		on_attach = lsp_attach,
		capabilities = lsp_capabilities,
	}

	lspconfig[server_name].setup(opts)
end

lspconfig.tsserver.setup({
	on_attach = lsp_attach,
	filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
	cmd = { "typescript-language-server", "--stdio" },
})

lspconfig.tailwindcss.setup({})

lspconfig.lua_ls.setup({
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
		},
	},
})

lspconfig.yamlls.setup({
	on_attach = lsp_attach,
	capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities()),
	settings = {
		yaml = {
			schemas = {
				["https://raw.githubusercontent.com/quantumblacklabs/kedro/develop/static/jsonschema/kedro-catalog-0.17.json"] = "conf/**/*catalog*",
				["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
			},
		},
	},
})
lspconfig.pyright.setup({
	on_attach = lsp_attach,
	settings = {
		python = {
			analysis = {
				typeCheckingMode = "off",
			},
		},
	},
})
