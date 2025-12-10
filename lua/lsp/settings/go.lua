--[[
═══════════════════════════════════════════════════════════════════
  Go Configuration

  Settings for Go development with:
  - gopls LSP
  - Go formatting (gofmt, goimports)
  - Testing integration
  - Debugging with delve
═══════════════════════════════════════════════════════════════════
--]]

local M = {}

M.settings = {
    gopls = {
        gofumpt = true,
        codelenses = {
            gc_details = false,
            generate = true,
            regenerate_cgo = true,
            run_govulncheck = true,
            test = true,
            tidy = true,
            upgrade_dependency = true,
            vendor = true,
        },
        hints = {
            assignVariableTypes = true,
            compositeLiteralFields = true,
            compositeLiteralTypes = true,
            constantValues = true,
            functionTypeParameters = true,
            parameterNames = true,
            rangeVariableTypes = true,
        },
        analyses = {
            fieldalignment = true,
            nilness = true,
            unusedparams = true,
            unusedwrite = true,
            useany = true,
        },
        usePlaceholders = true,
        completeUnimported = true,
        staticcheck = true,
        directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
        semanticTokens = true,
    },
}

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- Go Utilities
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

-- Run current Go file
M.run_go_file = function()
    local file = vim.fn.expand("%:p")
    vim.cmd("ToggleTerm")
    vim.fn.chansend(vim.b.toggle_number, "go run " .. file .. "\n")
end

-- Run Go tests in current package
M.run_go_test = function()
    vim.cmd("ToggleTerm")
    vim.fn.chansend(vim.b.toggle_number, "go test -v\n")
end

-- Run Go test for current function
M.run_go_test_func = function()
    local func_name = vim.fn.search("^func Test", "bn")
    if func_name == 0 then
        vim.notify("No test function found", vim.log.levels.WARN)
        return
    end

    local line = vim.fn.getline(func_name)
    local test_name = line:match("func (Test%w+)")

    if test_name then
        vim.cmd("ToggleTerm")
        vim.fn.chansend(vim.b.toggle_number, "go test -v -run " .. test_name .. "\n")
    end
end

-- Build Go project
M.build_go = function()
    vim.cmd("ToggleTerm")
    vim.fn.chansend(vim.b.toggle_number, "go build\n")
end

-- Install Go dependencies
M.install_deps = function()
    vim.cmd("ToggleTerm")
    vim.fn.chansend(vim.b.toggle_number, "go mod tidy\n")
end

-- Format with goimports
M.format_go = function()
    local file = vim.fn.expand("%:p")
    if vim.fn.executable("goimports") == 1 then
        vim.fn.system({ "goimports", "-w", file })
        vim.cmd("edit!")
        vim.notify("Formatted with goimports", vim.log.levels.INFO)
    else
        vim.notify("goimports not installed. Run: go install golang.org/x/tools/cmd/goimports@latest",
            vim.log.levels.WARN)
    end
end

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- Setup Go-specific keymaps and autocommands
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

M.setup_autocommands = function()
    local augroup = vim.api.nvim_create_augroup("GoSettings", { clear = true })

    -- Auto-format on save
    vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        pattern = "*.go",
        callback = function()
            local params = vim.lsp.util.make_range_params()
            params.context = { only = { "source.organizeImports" } }
            local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
            for _, res in pairs(result or {}) do
                for _, r in pairs(res.result or {}) do
                    if r.edit then
                        vim.lsp.util.apply_workspace_edit(r.edit, "utf-8")
                    else
                        vim.lsp.buf.execute_command(r.command)
                    end
                end
            end
            vim.lsp.buf.format({ async = false })
        end,
    })

    -- Set tab width to tabs (Go convention)
    vim.api.nvim_create_autocmd("FileType", {
        group = augroup,
        pattern = "go",
        callback = function()
            vim.opt_local.expandtab = false
            vim.opt_local.shiftwidth = 4
            vim.opt_local.tabstop = 4
            vim.opt_local.softtabstop = 4
        end,
    })
end

M.setup_keymaps = function(bufnr)
    local opts = { buffer = bufnr, silent = true }

    vim.keymap.set("n", "<leader>gr", M.run_go_file,
        vim.tbl_extend("force", opts, { desc = "Run Go file" }))
    vim.keymap.set("n", "<leader>gt", M.run_go_test,
        vim.tbl_extend("force", opts, { desc = "Run Go tests" }))
    vim.keymap.set("n", "<leader>gT", M.run_go_test_func,
        vim.tbl_extend("force", opts, { desc = "Run Go test function" }))
    vim.keymap.set("n", "<leader>gb", M.build_go,
        vim.tbl_extend("force", opts, { desc = "Build Go project" }))
    vim.keymap.set("n", "<leader>gi", M.install_deps,
        vim.tbl_extend("force", opts, { desc = "Go mod tidy" }))
    vim.keymap.set("n", "<leader>gf", M.format_go,
        vim.tbl_extend("force", opts, { desc = "Format with goimports" }))

    -- Which-key group
    local wk_ok, wk = pcall(require, "which-key")
    if wk_ok then
        wk.register({
            ["<leader>g"] = { name = "+go/git" },
        })
    end
end

return M
