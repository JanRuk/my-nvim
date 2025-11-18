--[[
═══════════════════════════════════════════════════════════════════
  Miscellaneous Plugins

  Additional utilities and enhancements
═══════════════════════════════════════════════════════════════════
--]]

return {
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- Comment.nvim (Smart commenting)
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    {
        "numToStr/Comment.nvim",
        event = { "BufReadPost", "BufNewFile" },
        dependencies = {
            "JoosepAlviste/nvim-ts-context-commentstring",
        },
        config = function()
            require("Comment").setup({
                pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
            })
        end,
    },

    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- Context Commentstring (for JSX, Vue, etc.)
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    {
        "JoosepAlviste/nvim-ts-context-commentstring",
        lazy = true,
        opts = {
            enable_autocmd = false,
        },
    },

    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- Surround (Manipulate surrounding characters)
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    {
        "kylechui/nvim-surround",
        version = "*",
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({})
        end,
    },

    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- Project Management
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    {
        "ahmedkhalf/project.nvim",
        event = "VeryLazy",
        config = function()
            require("project_nvim").setup({
                detection_methods = { "lsp", "pattern" },
                patterns = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle", "package.json", "requirements.txt" },
                ignore_lsp = {},
                exclude_dirs = {},
                show_hidden = false,
                silent_chdir = true,
                datapath = vim.fn.stdpath("data"),
            })

            -- Integrate with Telescope
            require("telescope").load_extension("projects")
        end,
        keys = {
            { "<leader>fp", "<cmd>Telescope projects<cr>", desc = "Find projects" },
        },
    },

    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- Todo Comments (Highlight TODO, FIXME, etc.)
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        event = { "BufReadPost", "BufNewFile" },
        opts = {
            signs = true,
            sign_priority = 8,
            keywords = {
                FIX = {
                    icon = " ",
                    color = "error",
                    alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },
                },
                TODO = { icon = " ", color = "info" },
                HACK = { icon = " ", color = "warning" },
                WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
                PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
                NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
                TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
            },
            merge_keywords = true,
            highlight = {
                multiline = true,
                multiline_pattern = "^.",
                multiline_context = 10,
                before = "",
                keyword = "wide",
                after = "fg",
                pattern = [[.*<(KEYWORDS)\s*:]],
                comments_only = true,
                max_line_len = 400,
                exclude = {},
            },
            colors = {
                error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
                warning = { "DiagnosticWarn", "WarningMsg", "#FBBF24" },
                info = { "DiagnosticInfo", "#2563EB" },
                hint = { "DiagnosticHint", "#10B981" },
                default = { "Identifier", "#7C3AED" },
                test = { "Identifier", "#FF00FF" },
            },
            search = {
                command = "rg",
                args = {
                    "--color=never",
                    "--no-heading",
                    "--with-filename",
                    "--line-number",
                    "--column",
                },
                pattern = [[\b(KEYWORDS):]],
            },
        },
        keys = {
            { "]t",         function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
            { "[t",         function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
            { "<leader>ft", "<cmd>TodoTelescope<cr>",                            desc = "Find todos" },
        },
    },

    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- Better Quickfix
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    {
        "kevinhwang91/nvim-bqf",
        ft = "qf",
        opts = {
            auto_enable = true,
            preview = {
                win_height = 12,
                win_vheight = 12,
                delay_syntax = 80,
                border = "rounded",
            },
            func_map = {
                vsplit = "",
                ptogglemode = "z,",
                stoggleup = "",
            },
            filter = {
                fzf = {
                    action_for = { ["ctrl-s"] = "split" },
                    extra_opts = { "--bind", "ctrl-o:toggle-all", "--prompt", "> " },
                },
            },
        },
    },

    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- Smooth Scrolling
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    {
        "karb94/neoscroll.nvim",
        event = "VeryLazy",
        config = function()
            require("neoscroll").setup({
                mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "<C-e>", "zt", "zz", "zb" },
                hide_cursor = true,
                stop_eof = true,
                respect_scrolloff = false,
                cursor_scrolls_alone = true,
                easing_function = "quadratic",
                pre_hook = nil,
                post_hook = nil,
            })
        end,
    },

    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- Dashboard (Start screen)
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    {
        "goolord/alpha-nvim",
        event = "VimEnter",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            local alpha = require("alpha")
            local dashboard = require("alpha.themes.dashboard")

            -- Header
            -- Header
            dashboard.section.header.val = {
                "                                                     ",
                "     ██╗ █████╗ ███╗   ██╗██╗███╗   ██╗██████╗  █████╗  ",
                "     ██║██╔══██╗████╗  ██║██║████╗  ██║██╔══██╗██╔══██╗ ",
                "     ██║███████║██╔██╗ ██║██║██╔██╗ ██║██║  ██║███████║ ",
                "██   ██║██╔══██║██║╚██╗██║██║██║╚██╗██║██║  ██║██╔══██║ ",
                "╚█████╔╝██║  ██║██║ ╚████║██║██║ ╚████║██████╔╝██║  ██║ ",
                " ╚════╝ ╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝╚═╝  ╚═══╝╚═════╝ ╚═╝  ╚═╝ ",
                "                                                     ",
            }
            -- Buttons
            dashboard.section.buttons.val = {
                dashboard.button("f", "  Find file", ":Telescope find_files <CR>"),
                dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
                dashboard.button("p", "  Find project", ":Telescope projects <CR>"),
                dashboard.button("r", "  Recently used files", ":Telescope oldfiles <CR>"),
                dashboard.button("t", "  Find text", ":Telescope live_grep <CR>"),
                dashboard.button("c", "  Configuration", ":e $MYVIMRC <CR>"),
                dashboard.button("q", "  Quit Neovim", ":qa<CR>"),
            }

            -- Footer
            local function footer()
                local total_plugins = require("lazy").stats().count
                local datetime = os.date(" %d-%m-%Y   %H:%M:%S")
                local version = vim.version()
                local nvim_version_info = "   v" .. version.major .. "." .. version.minor .. "." .. version.patch

                return datetime .. "   " .. total_plugins .. " plugins" .. nvim_version_info
            end

            dashboard.section.footer.val = footer()

            dashboard.section.footer.opts.hl = "Type"
            dashboard.section.header.opts.hl = "Include"
            dashboard.section.buttons.opts.hl = "Keyword"

            dashboard.opts.opts.noautocmd = true
            alpha.setup(dashboard.opts)
        end,
    },

    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- Colorizer (Show hex colors)
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    {
        "NvChad/nvim-colorizer.lua",
        event = { "BufReadPost", "BufNewFile" },
        opts = {
            filetypes = { "*" },
            user_default_options = {
                RGB = true,
                RRGGBB = true,
                names = true,
                RRGGBBAA = true,
                AARRGGBB = false,
                rgb_fn = true,
                hsl_fn = true,
                css = true,
                css_fn = true,
                mode = "background",
                tailwind = true,
            },
            buftypes = {},
        },
    },

    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- Database UI (vim-dadbod)
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    {
        "tpope/vim-dadbod",
        cmd = "DB",
    },

    {
        "kristijanhusak/vim-dadbod-ui",
        dependencies = {
            "tpope/vim-dadbod",
            "kristijanhusak/vim-dadbod-completion",
        },
        cmd = {
            "DBUI",
            "DBUIToggle",
            "DBUIAddConnection",
            "DBUIFindBuffer",
        },
        keys = {
            { "<leader>Du", "<cmd>DBUIToggle<cr>",        desc = "Toggle DBUI" },
            { "<leader>Df", "<cmd>DBUIFindBuffer<cr>",    desc = "Find buffer" },
            { "<leader>Dr", "<cmd>DBUIRenameBuffer<cr>",  desc = "Rename buffer" },
            { "<leader>Dq", "<cmd>DBUILastQueryInfo<cr>", desc = "Last query info" },
        },
        init = function()
            vim.g.db_ui_use_nerd_fonts = 1
            vim.g.db_ui_show_database_icon = 1
            vim.g.db_ui_force_echo_notifications = 1
            vim.g.db_ui_win_position = "left"
            vim.g.db_ui_winwidth = 40

            vim.g.db_ui_table_helpers = {
                mysql = {
                    Count = "select count(1) from {optional_schema}{table}",
                    Explain = "EXPLAIN {last_query}",
                },
                postgresql = {
                    Count = "select count(1) from {optional_schema}{table}",
                    Explain = "EXPLAIN ANALYZE {last_query}",
                },
            }

            -- Auto-completion for SQL
            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "sql", "mysql", "plsql" },
                callback = function()
                    require("cmp").setup.buffer({
                        sources = {
                            { name = "vim-dadbod-completion" },
                            { name = "buffer" },
                        },
                    })
                end,
            })
        end,
    },

    {
        "kristijanhusak/vim-dadbod-completion",
        dependencies = "vim-dadbod",
        ft = { "sql", "mysql", "plsql" },
    },

    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- Session Management
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    {
        "folke/persistence.nvim",
        event = "BufReadPre",
        opts = {
            dir = vim.fn.expand(vim.fn.stdpath("state") .. "/sessions/"),
            options = { "buffers", "curdir", "tabpages", "winsize" },
        },
        keys = {
            { "<leader>qs", function() require("persistence").load() end,                desc = "Restore session" },
            { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore last session" },
            { "<leader>qd", function() require("persistence").stop() end,                desc = "Don't save session" },
        },
    },

    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- Better UI for vim.ui.select and vim.ui.input
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    {
        "stevearc/dressing.nvim",
        event = "VeryLazy",
        opts = {
            input = {
                enabled = true,
                default_prompt = "Input:",
                prompt_align = "left",
                insert_only = true,
                start_in_insert = true,
                border = "rounded",
                relative = "cursor",
                prefer_width = 40,
                width = nil,
                max_width = { 140, 0.9 },
                min_width = { 20, 0.2 },
                win_options = {
                    winblend = 0,
                    wrap = false,
                },
            },
            select = {
                enabled = true,
                backend = { "telescope", "fzf_lua", "fzf", "builtin", "nui" },
                trim_prompt = true,
                telescope = nil, -- Will be set after telescope loads
            },
        },
    },

    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- Tmux Navigation Integration
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    {
        "christoomey/vim-tmux-navigator",
        cmd = {
            "TmuxNavigateLeft",
            "TmuxNavigateDown",
            "TmuxNavigateUp",
            "TmuxNavigateRight",
            "TmuxNavigatePrevious",
        },
        keys = {
            { "<c-h>",  "<cmd>TmuxNavigateLeft<cr>" },
            { "<c-j>",  "<cmd>TmuxNavigateDown<cr>" },
            { "<c-k>",  "<cmd>TmuxNavigateUp<cr>" },
            { "<c-l>",  "<cmd>TmuxNavigateRight<cr>" },
            { "<c-\\>", "<cmd>TmuxNavigatePrevious<cr>" },
        },
    },

    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- Markdown Preview
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = function()
            vim.fn["mkdp#util#install"]()
        end,
        keys = {
            { "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown preview" },
        },
    },

    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- REST Client (HTTP requests)
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    {
        "rest-nvim/rest.nvim",
        ft = "http",
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = {
            { "<leader>rr", "<Plug>RestNvim",        desc = "Run REST request" },
            { "<leader>rp", "<Plug>RestNvimPreview", desc = "Preview REST request" },
            { "<leader>rl", "<Plug>RestNvimLast",    desc = "Run last REST request" },
        },
        config = function()
            require("rest-nvim").setup({
                result_split_horizontal = false,
                result_split_in_place = false,
                skip_ssl_verification = false,
                encode_url = true,
                highlight = {
                    enabled = true,
                    timeout = 150,
                },
                result = {
                    show_url = true,
                    show_http_info = true,
                    show_headers = true,
                    formatters = {
                        json = "jq",
                        html = function(body)
                            return vim.fn.system({ "tidy", "-i", "-q", "-" }, body)
                        end,
                    },
                },
                jump_to_request = false,
                env_file = ".env",
                custom_dynamic_variables = {},
                yank_dry_run = true,
            })
        end,
    },
}

