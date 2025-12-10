--[[
═══════════════════════════════════════════════════════════════════
  Debug Adapter Protocol (DAP) Configuration

  Debugging support for:
  - Java (via jdtls)
  - Python (debugpy)
  - JavaScript/TypeScript (node-debug2, chrome-debug)
  - Go (delve)
═══════════════════════════════════════════════════════════════════
--]]

return {
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- DAP Core
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "theHamsta/nvim-dap-virtual-text",
            "nvim-neotest/nvim-nio",
        },
        keys = {
            { "<F5>",       function() require("dap").continue() end,                                             desc = "Debug: Continue" },
            { "<F10>",      function() require("dap").step_over() end,                                            desc = "Debug: Step Over" },
            { "<F11>",      function() require("dap").step_into() end,                                            desc = "Debug: Step Into" },
            { "<F12>",      function() require("dap").step_out() end,                                             desc = "Debug: Step Out" },
            { "<leader>db", function() require("dap").toggle_breakpoint() end,                                    desc = "Toggle breakpoint" },
            { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, desc = "Conditional breakpoint" },
            { "<leader>dr", function() require("dap").repl.open() end,                                            desc = "Open REPL" },
            { "<leader>dl", function() require("dap").run_last() end,                                             desc = "Run last" },
            { "<leader>dt", function() require("dapui").toggle() end,                                             desc = "Toggle DAP UI" },
        },
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")

            -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
            -- DAP UI Setup
            -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
            dapui.setup({
                icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
                mappings = {
                    expand = { "<CR>", "<2-LeftMouse>" },
                    open = "o",
                    remove = "d",
                    edit = "e",
                    repl = "r",
                    toggle = "t",
                },
                layouts = {
                    {
                        elements = {
                            { id = "scopes",      size = 0.25 },
                            { id = "breakpoints", size = 0.25 },
                            { id = "stacks",      size = 0.25 },
                            { id = "watches",     size = 0.25 },
                        },
                        size = 40,
                        position = "left",
                    },
                    {
                        elements = {
                            { id = "repl",    size = 0.5 },
                            { id = "console", size = 0.5 },
                        },
                        size = 10,
                        position = "bottom",
                    },
                },
                controls = {
                    enabled = true,
                    element = "repl",
                    icons = {
                        pause = "",
                        play = "",
                        step_into = "",
                        step_over = "",
                        step_out = "",
                        step_back = "",
                        run_last = "↻",
                        terminate = "□",
                    },
                },
                floating = {
                    max_height = nil,
                    max_width = nil,
                    border = "rounded",
                    mappings = {
                        close = { "q", "<Esc>" },
                    },
                },
                windows = { indent = 1 },
                render = {
                    max_type_length = nil,
                    max_value_lines = 100,
                },
            })

            -- Auto-open/close DAP UI
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end

            -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
            -- DAP Signs
            -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
            vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
            vim.fn.sign_define("DapBreakpointCondition",
                { text = "◆", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
            vim.fn.sign_define("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })
            vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DapStopped", linehl = "DapStoppedLine", numhl = "" })
            vim.fn.sign_define("DapBreakpointRejected",
                { text = "○", texthl = "DapBreakpointRejected", linehl = "", numhl = "" })

            -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
            -- Python Debugger (debugpy)
            -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
            dap.adapters.python = function(cb, config)
                if config.request == "attach" then
                    local port = (config.connect or config).port
                    local host = (config.connect or config).host or "127.0.0.1"
                    cb({
                        type = "server",
                        port = assert(port, "`connect.port` is required for a python `attach` configuration"),
                        host = host,
                        options = {
                            source_filetype = "python",
                        },
                    })
                else
                    cb({
                        type = "executable",
                        command = vim.g.python3_host_prog or "python3",
                        args = { "-m", "debugpy.adapter" },
                        options = {
                            source_filetype = "python",
                        },
                    })
                end
            end

            dap.configurations.python = {
                {
                    type = "python",
                    request = "launch",
                    name = "Launch file",
                    program = "${file}",
                    pythonPath = function()
                        local venv = vim.env.VIRTUAL_ENV
                        if venv then
                            return venv .. "/bin/python"
                        else
                            return vim.g.python3_host_prog or "python3"
                        end
                    end,
                },
                {
                    type = "python",
                    request = "launch",
                    name = "Launch file with arguments",
                    program = "${file}",
                    args = function()
                        local args_string = vim.fn.input("Arguments: ")
                        return vim.split(args_string, " +")
                    end,
                    pythonPath = function()
                        local venv = vim.env.VIRTUAL_ENV
                        if venv then
                            return venv .. "/bin/python"
                        else
                            return vim.g.python3_host_prog or "python3"
                        end
                    end,
                },
                {
                    type = "python",
                    request = "launch",
                    name = "Django",
                    program = "${workspaceFolder}/manage.py",
                    args = { "runserver", "--noreload" },
                    console = "integratedTerminal",
                    pythonPath = function()
                        local venv = vim.env.VIRTUAL_ENV
                        if venv then
                            return venv .. "/bin/python"
                        else
                            return vim.g.python3_host_prog or "python3"
                        end
                    end,
                },
                {
                    type = "python",
                    request = "launch",
                    name = "Flask",
                    module = "flask",
                    env = {
                        FLASK_APP = "app.py",
                    },
                    args = { "run", "--no-debugger", "--no-reload" },
                    console = "integratedTerminal",
                    pythonPath = function()
                        local venv = vim.env.VIRTUAL_ENV
                        if venv then
                            return venv .. "/bin/python"
                        else
                            return vim.g.python3_host_prog or "python3"
                        end
                    end,
                },
            }

            -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
            -- Node.js Debugger (for JavaScript/TypeScript)
            -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
            dap.adapters.node2 = {
                type = "executable",
                command = "node",
                args = { vim.fn.stdpath("data") .. "/mason/packages/node-debug2-adapter/out/src/nodeDebug.js" },
            }

            dap.configurations.javascript = {
                {
                    type = "node2",
                    request = "launch",
                    name = "Launch Program",
                    program = "${file}",
                    cwd = vim.fn.getcwd(),
                    sourceMaps = true,
                    protocol = "inspector",
                    console = "integratedTerminal",
                },
                {
                    type = "node2",
                    request = "attach",
                    name = "Attach to Process",
                    processId = require("dap.utils").pick_process,
                    cwd = vim.fn.getcwd(),
                    sourceMaps = true,
                    protocol = "inspector",
                },
            }

            dap.configurations.typescript = dap.configurations.javascript

            -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
            -- Go Debugger (Delve)
            -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
            dap.adapters.delve = {
                type = "server",
                port = "${port}",
                executable = {
                    command = "dlv",
                    args = { "dap", "-l", "127.0.0.1:${port}" },
                },
            }

            dap.configurations.go = {
                {
                    type = "delve",
                    name = "Debug",
                    request = "launch",
                    program = "${file}",
                },
                {
                    type = "delve",
                    name = "Debug test",
                    request = "launch",
                    mode = "test",
                    program = "${file}",
                },
                {
                    type = "delve",
                    name = "Debug test (go.mod)",
                    request = "launch",
                    mode = "test",
                    program = "./${relativeFileDirname}",
                },
            }

            -- Java debugging is configured via jdtls in lua/lsp/settings/java.lua
        end,
    },

    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- DAP UI
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    {
        "rcarriga/nvim-dap-ui",
        dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
        lazy = true,
    },

    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- Virtual Text (Show variable values inline)
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    {
        "theHamsta/nvim-dap-virtual-text",
        dependencies = { "mfussenegger/nvim-dap" },
        opts = {
            enabled = true,
            enabled_commands = true,
            highlight_changed_variables = true,
            highlight_new_as_changed = false,
            show_stop_reason = true,
            commented = false,
            only_first_definition = true,
            all_references = false,
            filter_references_pattern = "<module",
            virt_text_pos = "eol",
            all_frames = false,
            virt_lines = false,
            virt_text_win_col = nil,
        },
    },

    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- Mason DAP (Auto-install debug adapters)
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = {
            "williamboman/mason.nvim",
            "mfussenegger/nvim-dap",
        },
        cmd = { "DapInstall", "DapUninstall" },
        opts = {
            ensure_installed = {
                "python", -- debugpy
                "javadbg", -- Java Debug Server
                "javatest", -- Java Test Runner
                "node2", -- Node.js debugger
                "delve", -- Go debugger
            },
            automatic_installation = true,
            handlers = {},
        },
    },
}
