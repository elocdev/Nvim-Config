local lspconfig = require("lspconfig")

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }

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

for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

local augroup_format = vim.api.nvim_create_augroup("Format", { clear = true })
local enable_format_on_save = function(_, bufnr)
    vim.api.nvim_clear_autocmds({ group = augroup_format, buffer = bufnr })
    vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup_format,
        buffer = bufnr,
        callback = function()
            vim.lsp.buf.format({ bufnr = bufnr })
        end,
    })
end

require("mason").setup(settings)
require("mason-lspconfig").setup({
    ensure_installed = servers,
    automatic_installation = true,
})

local protocol = require("vim.lsp.protocol")
local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Give floating windows borders
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "rounded",
})

-- Configure diagnostic display
vim.diagnostic.config({
    -- virtual_text = true,
    virtual_text = {
        -- Only display errors w/ virtual text
        severity = { vim.diagnostic.severity.ERROR, vim.diagnostic.severity.WARN },
        -- Prepend with diagnostic source if there is more than one attached to the buffer
        -- (e.g. (eslint) Error: blah blah blah)
        source = "if_many",
        signs = true,
    },
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
    severity_sort = true,
    signs = {
        active = signs,
    },
    update_in_insert = true,
})

-- restricted format
local custom_format = function(bufnr, allowed_clients)
    vim.lsp.buf.format({
        bufnr = bufnr,
        filter = function(client)
            if not allowed_clients then
                return true
            end
            return vim.tbl_contains(allowed_clients, client.name)
        end,
    })
end

local format_group = vim.api.nvim_create_augroup("LspFormatting", { clear = true })

local format_on_save = function(bufnr, allowed_clients)
    vim.api.nvim_create_autocmd("BufWritePre", {
        group = format_group,
        buffer = bufnr,
        callback = function()
            custom_format(bufnr, allowed_clients)
        end,
    })
end

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

local custom_attach = function(client, bufnr, formatters)
    -- LSP mappings (only apply when LSP client attached)
    local keymap_opts = { buffer = bufnr, silent = true, noremap = true }
    local with_desc = function(opts, desc)
        return vim.tbl_extend("force", opts, { desc = desc })
    end
    vim.keymap.set("n", "K", vim.lsp.buf.hover, with_desc(keymap_opts, "Hover"))
    vim.keymap.set("n", "<gd>", vim.lsp.buf.definition, with_desc(keymap_opts, "Goto Definition"))
    vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, with_desc(keymap_opts, "Find References"))
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, with_desc(keymap_opts, "Rename"))
    vim.keymap.set("n", "<leader>gi", vim.lsp.buf.implementation, with_desc(keymap_opts, "Rename"))

    -- diagnostics
    vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, with_desc(keymap_opts, "View Current Diagnostic")) -- diagnostic(s) on current line
    vim.keymap.set("n", "<leader>dn", vim.diagnostic.goto_next, with_desc(keymap_opts, "Goto next diagnostic"))  -- move to next diagnostic in buffer
    vim.keymap.set("n", "<leader>dp", vim.diagnostic.goto_prev, with_desc(keymap_opts, "Goto prev diagnostic"))  -- move to prev diagnostic in buffer
    vim.keymap.set("n", "<leader>ca", function()
        -- make sure telescope is loaded for code actions
        require("telescope").load_extension("ui-select")
        vim.lsp.buf.code_action()
    end, with_desc(keymap_opts, "Code Actions")) -- code actions (handled by telescope-ui-select)
    vim.keymap.set("n", "<leader>F", function()
        custom_format(bufnr, formatters)
    end, with_desc(keymap_opts, "Format")) -- format

    -- use omnifunc
    vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
    vim.bo[bufnr].formatexpr = "v:lua.vim.lsp.formatexpr"
    lsp_highlight_document(client)
end

--#region Set up clients
-- Formatting via (efm-langserver)[https://github.com/mattn/efm-langserver]
lspconfig.efm.setup({
    on_attach = function(client, bufnr)
        custom_attach(client, bufnr, { "efm" })
    end,
    init_options = {
        documentFormatting = true,
    },
    settings = {
        languages = {
            lua = {
                require("efmls-configs.formatters.stylua"),
            },
            typescript = {
                require("efmls-configs.linters.eslint_d"),
                require("efmls-configs.formatters.prettier_d"),
                require("efmls-configs.formatters.eslint_d"),
            },
            javascript = {
                require("efmls-configs.formatters.prettier_d"),
                require("efmls-configs.formatters.eslint_d"),
                require("efmls-configs.linters.eslint_d"),
            },
            python = {
                require("efmls-configs.formatters.black"),
                require("efmls-configs.linters.flake8"),
            },
            css = {
                require("efmls-configs.formatters.prettier"),
                require("efmls-configs.linters.stylelint"),
            },
            vim = {
                require("efmls-configs.linters.vint"),
            },
            yaml = {
                require("efmls-configs.formatters.prettier"),
            },
            json = {
                require("efmls-configs.formatters.prettier_d"),
                require("efmls-configs.linters.eslint"),
            },
        },
    },
    filetypes = { "lua", "typescript", "javascript", "vue", "python", "css", "vim", "yaml", "json" },
})

-- python
lspconfig.pyright.setup({
    on_attach = function(client, bufnr)
        custom_attach(client, bufnr, { "efm" })
        -- 'Organize imports' keymap for pyright only
        vim.keymap.set("n", "<Leader>ii", "<cmd>PyrightOrganizeImports<CR>", {
            buffer = bufnr,
            silent = true,
            noremap = true,
        })
        enable_format_on_save(client, bufnr)
    end,
    settings = {
        pyright = {
            disableOrganizeImports = false,
            analysis = {
                useLibraryCodeForTypes = true,
                autoSearchPaths = true,
                diagnosticMode = "workspace",
                autoImportCompletions = true,
            },
        },
    },
})

lspconfig.volar.setup({
    on_attach = function(client, bufnr)
        custom_attach(client, bufnr, { "efm" })
    end,
    -- enable "take over mode" for typescript files as well: https://github.com/johnsoncodehk/volar/discussions/471
    filetypes = { "typescript", "javascript", "vue" },
})

-- yaml
lspconfig.yamlls.setup({
    on_attach = custom_attach,
})

-- lua
lspconfig.lua_ls.setup({
    on_attach = function(client, bufnr)
        custom_attach(client, bufnr, { "efm" })
        enable_format_on_save(client, bufnr)
    end,
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = "LuaJIT",
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { "vim" },
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
        },
    },
})

-- json w/ common schemas
lspconfig.jsonls.setup({
    on_attach = custom_attach,
    settings = {
        json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
        },
    },
})

-- rust
lspconfig.rust_analyzer.setup({
    on_attach = custom_attach,
})

--#endregion
lspconfig.tsserver.setup({
    on_attach = function(client, bufnr)
        custom_attach(client, bufnr, { "tsserver" })
    end,
    filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
    cmd = { "typescript-language-server", "--stdio" },
})

lspconfig.tailwindcss.setup({})
