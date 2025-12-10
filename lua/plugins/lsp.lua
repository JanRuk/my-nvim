--[[
═══════════════════════════════════════════════════════════════════
  LSP Configuration

  Mason for LSP server management
  nvim-lspconfig for server configurations
═══════════════════════════════════════════════════════════════════
--]]

return {
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- Mason: LSP Server Manager
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    {
        "williamboman/mason.nvim",
        cmd = "Mason",
        build = ":MasonUpdate",
        keys = {
            { "<leader>lm", "<cmd>Mason<cr>", desc = "Mason" },
        },
        config = function()
            require("mason").setup({
                ui = {
                    border = "rounded",
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜",
                        package_uninstalled = "✗",
                    },
                },
                max_concurrent_installers = 10,
            })
        end,
    },

    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- Mason-LSPConfig Bridge
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            "williamboman/mason.nvim",
            "neovim/nvim-lspconfig",
        },
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("mason-lspconfig").setup({
                -- Automatically install these LSP servers
                ensure_installed = {
                    -- Java
                    "jdtls", -- Java LSP (will be configured separately)

                    -- JavaScript/TypeScript
                    "ts_ls",  -- TypeScript/JavaScript
                    "eslint", -- ESLint linting

                    -- Python
                    "pyright", -- Python LSP

                    -- Web
                    "html",   -- HTML
                    "cssls",  -- CSS
                    "jsonls", -- JSON

                    -- DevOps
                    "yamlls",                          -- YAML
                    "dockerls",                        -- Dockerfile
                    "docker_compose_language_service", -- Docker Compose

                    -- SQL
                    "sqlls", -- SQL

                    -- Lua (for Neovim config)
                    "lua_ls", -- Lua
                    "gopls",
                    --"golangci_lint_ls",
                },

                -- Auto-install missing servers on startup
                automatic_installation = true,
            })
        end,
    },

    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- LSP Configuration
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            -- Setup is handled in lua/lsp/handlers.lua and lua/lsp/servers.lua
            -- This ensures proper load order after plugins are initialized
        end,
    },

    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- Java LSP (jdtls) - Separate configuration
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    {
        "mfussenegger/nvim-jdtls",
        ft = "java",
        dependencies = {
            "mfussenegger/nvim-dap",
        },
        -- Configuration is in lua/lsp/settings/java.lua
    },

    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- LSP Signature Help
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    {
        "ray-x/lsp_signature.nvim",
        event = "VeryLazy",
        opts = {
            bind = true,
            handler_opts = {
                border = "rounded",
            },
            hint_enable = false,
            floating_window = true,
            floating_window_above_cur_line = true,
        },
    },

    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- Formatting & Linting
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        keys = {
            {
                "<leader>lf",
                function()
                    require("conform").format({ async = true, lsp_fallback = true })
                end,
                mode = "",
                desc = "Format buffer",
            },
        },
        opts = {
            formatters_by_ft = {
                python = { "black", "isort" },
                javascript = { "prettier" },
                typescript = { "prettier" },
                javascriptreact = { "prettier" },
                typescriptreact = { "prettier" },
                css = { "prettier" },
                html = { "prettier" },
                json = { "prettier" },
                yaml = { "prettier" },
                markdown = { "prettier" },
                lua = { "stylua" },
                go = { "goimports", "gofumpt" },
            },
            format_on_save = function(bufnr)
                -- Disable with a global or buffer-local variable
                if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                    return
                end
                return { timeout_ms = 500, lsp_fallback = true }
            end,
        },
        init = function()
            -- If you want to format on save, enable this
            vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

            -- Commands to toggle format-on-save
            vim.api.nvim_create_user_command("FormatDisable", function(args)
                if args.bang then
                    vim.b.disable_autoformat = true
                else
                    vim.g.disable_autoformat = true
                end
            end, {
                desc = "Disable autoformat-on-save",
                bang = true,
            })

            vim.api.nvim_create_user_command("FormatEnable", function()
                vim.b.disable_autoformat = false
                vim.g.disable_autoformat = false
            end, {
                desc = "Re-enable autoformat-on-save",
            })
        end,
    },

    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- Diagnostics UI Enhancement
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        cmd = { "Trouble", "TroubleToggle" },
        keys = {
            { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>",                        desc = "Diagnostics (Trouble)" },
            { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",           desc = "Buffer Diagnostics (Trouble)" },
            { "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>",                desc = "Symbols (Trouble)" },
            { "<leader>xl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP Definitions / references / ... (Trouble)" },
            { "<leader>xL", "<cmd>Trouble loclist toggle<cr>",                            desc = "Location List (Trouble)" },
            { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>",                             desc = "Quickfix List (Trouble)" },
        },
        opts = {},
    },

    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- Code Outline
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    {
        "stevearc/aerial.nvim",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
        },
        cmd = { "AerialToggle", "AerialOpen" },
        keys = {
            { "<leader>lo", "<cmd>AerialToggle<cr>", desc = "Toggle code outline" },
        },
        opts = {
            backends = { "lsp", "treesitter", "markdown" },
            layout = {
                max_width = { 40, 0.2 },
                width = nil,
                min_width = 30,
                default_direction = "right",
            },
            attach_mode = "global",
            filter_kind = false,
            show_guides = true,
            guides = {
                mid_item = "├─",
                last_item = "└─",
                nested_top = "│ ",
                whitespace = "  ",
            },
        },
    },
    {
        "b0o/schemastore.nvim",
        lazy = true,
    },
}

-- Add this to lua/plugins/lsp.lua return table
