--[[
═══════════════════════════════════════════════════════════════════
  Go Language Plugins

  Additional Go tooling and enhancements
═══════════════════════════════════════════════════════════════════
--]]

return {
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- Go.nvim (Swiss Army Knife for Go)
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    {
        "ray-x/go.nvim",
        dependencies = {
            "ray-x/guihua.lua",
            "neovim/nvim-lspconfig",
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
            require("go").setup({
                disable_defaults = false,
                go = "go",
                goimports = "gopls",
                fillstruct = "gopls",
                gofmt = "gofumpt",
                max_line_len = 120,
                tag_transform = false,
                test_dir = "",
                comment_placeholder = "   ",
                lsp_cfg = false, -- Use our own LSP config
                lsp_gofumpt = true,
                lsp_on_attach = false,
                dap_debug = true,
                dap_debug_gui = true,
                dap_debug_keymap = true,
                dap_vt = true,
                build_tags = "",
                textobjects = true,
                test_runner = "go",
                verbose_tests = true,
                run_in_floaterm = false,
                trouble = true,
                test_efm = false,
                luasnip = true,
            })

            -- Auto commands
            local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
            vim.api.nvim_create_autocmd("BufWritePre", {
                pattern = "*.go",
                callback = function()
                    require("go.format").goimport()
                end,
                group = format_sync_grp,
            })
        end,
        event = { "CmdlineEnter" },
        ft = { "go", "gomod" },
        build = ':lua require("go.install").update_all_sync()',
    },
}
