--[[
═══════════════════════════════════════════════════════════════════
  Auto Commands
  
  Automated behaviors and file-specific settings
═══════════════════════════════════════════════════════════════════
--]]

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- General Auto Commands
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
local general = augroup("General", { clear = true })

-- Highlight yanked text
autocmd("TextYankPost", {
  group = general,
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
  desc = "Highlight yanked text",
})

-- Auto-reload file if changed outside Neovim
autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  group = general,
  pattern = "*",
  command = "checktime",
  desc = "Check if file needs to be reloaded",
})

-- Remove trailing whitespace on save
autocmd("BufWritePre", {
  group = general,
  pattern = "*",
  command = "%s/\\s\\+$//e",
  desc = "Remove trailing whitespace",
})

-- Restore cursor position when opening file
autocmd("BufReadPost", {
  group = general,
  pattern = "*",
  callback = function()
    local line = vim.fn.line("'\"")
    if line > 1 and line <= vim.fn.line("$") then
      vim.cmd('normal! g`"')
    end
  end,
  desc = "Restore cursor position",
})

-- Close certain filetypes with 'q'
autocmd("FileType", {
  group = general,
  pattern = {
    "help",
    "qf",
    "lspinfo",
    "man",
    "checkhealth",
    "startuptime",
    "notify",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
  desc = "Close with q",
})

-- Disable auto-comment on new line
autocmd("BufEnter", {
  group = general,
  pattern = "*",
  callback = function()
    vim.opt.formatoptions:remove({ "c", "r", "o" })
  end,
  desc = "Disable auto-comment",
})

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- File Type Specific Settings
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
local filetype_settings = augroup("FileTypeSettings", { clear = true })

-- Java: Set tab width to 4 spaces
autocmd("FileType", {
  group = filetype_settings,
  pattern = "java",
  callback = function()
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.expandtab = true
  end,
  desc = "Java indentation settings",
})

-- Python: Set tab width to 4 spaces (PEP 8)
autocmd("FileType", {
  group = filetype_settings,
  pattern = "python",
  callback = function()
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.expandtab = true
    vim.opt_local.textwidth = 88  -- Black formatter default
    vim.opt_local.colorcolumn = "88"
  end,
  desc = "Python indentation settings",
})

-- JavaScript/TypeScript/React: 2 spaces
autocmd("FileType", {
  group = filetype_settings,
  pattern = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.expandtab = true
  end,
  desc = "JS/TS indentation settings",
})

-- JSON/YAML/HTML/CSS: 2 spaces
autocmd("FileType", {
  group = filetype_settings,
  pattern = { "json", "yaml", "yml", "html", "css", "scss", "xml" },
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.expandtab = true
  end,
  desc = "Config file indentation",
})

-- SQL: Enable spell check and wrap
autocmd("FileType", {
  group = filetype_settings,
  pattern = "sql",
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
  end,
  desc = "SQL settings",
})

-- Markdown: Enable spell check and wrap
autocmd("FileType", {
  group = filetype_settings,
  pattern = { "markdown", "md", "text" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.spell = true
    vim.opt_local.spelllang = "en_us"
  end,
  desc = "Markdown/text settings",
})

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- LSP-Related Auto Commands
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
local lsp_autoformat = augroup("LspAutoformat", { clear = true })

-- Auto-format on save (for specific languages)
-- Note: This will be configured per-buffer when LSP attaches
-- Enabled for: Python (black/isort), JS/TS (prettier), JSON, YAML
autocmd("BufWritePre", {
  group = lsp_autoformat,
  pattern = { "*.py", "*.js", "*.jsx", "*.ts", "*.tsx", "*.json", "*.yaml", "*.yml" },
  callback = function()
    -- Only format if LSP is attached and supports formatting
    local bufnr = vim.api.nvim_get_current_buf()
    local clients = vim.lsp.get_active_clients({ bufnr = bufnr })
    
    for _, client in ipairs(clients) do
      if client.server_capabilities.documentFormattingProvider then
        vim.lsp.buf.format({
          async = false,
          bufnr = bufnr,
          timeout_ms = 2000,
        })
        break
      end
    end
  end,
  desc = "Auto-format on save",
})

-- Show line diagnostics automatically in hover window
autocmd("CursorHold", {
  group = augroup("LspDiagnostics", { clear = true }),
  callback = function()
    local opts = {
      focusable = false,
      close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
      border = "rounded",
      source = "always",
      prefix = " ",
      scope = "cursor",
    }
    vim.diagnostic.open_float(nil, opts)
  end,
  desc = "Show diagnostics on cursor hold",
})

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- Terminal Auto Commands
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
local terminal = augroup("Terminal", { clear = true })

-- Enter insert mode when opening terminal
autocmd("TermOpen", {
  group = terminal,
  pattern = "*",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
    vim.cmd("startinsert")
  end,
  desc = "Terminal settings",
})

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- Window Management
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
local windows = augroup("Windows", { clear = true })

-- Auto-resize splits when Neovim is resized
autocmd("VimResized", {
  group = windows,
  pattern = "*",
  command = "tabdo wincmd =",
  desc = "Auto-resize splits",
})

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- Git Commit Messages
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
local git = augroup("Git", { clear = true })

autocmd("FileType", {
  group = git,
  pattern = "gitcommit",
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.wrap = true
    vim.opt_local.textwidth = 72
    vim.opt_local.colorcolumn = "50,72"
  end,
  desc = "Git commit settings",
})

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- Project-Specific Settings
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
local project = augroup("Project", { clear = true })

-- Detect Python virtual environments
autocmd({ "BufEnter", "DirChanged" }, {
  group = project,
  pattern = "*.py",
  callback = function()
    local venv_paths = { ".venv", "venv", "env", ".env" }
    local cwd = vim.fn.getcwd()
    
    for _, venv in ipairs(venv_paths) do
      local venv_python = cwd .. "/" .. venv .. "/bin/python"
      if vim.fn.filereadable(venv_python) == 1 then
        vim.g.python3_host_prog = venv_python
        break
      end
    end
  end,
  desc = "Detect Python virtualenv",
})

-- Maven/Gradle project detection
autocmd({ "BufEnter", "DirChanged" }, {
  group = project,
  pattern = "*.java",
  callback = function()
    local cwd = vim.fn.getcwd()
    
    -- Check for Maven
    if vim.fn.filereadable(cwd .. "/pom.xml") == 1 then
      vim.b.java_project_type = "maven"
    -- Check for Gradle
    elseif vim.fn.filereadable(cwd .. "/build.gradle") == 1 or
           vim.fn.filereadable(cwd .. "/build.gradle.kts") == 1 then
      vim.b.java_project_type = "gradle"
    end
  end,
  desc = "Detect Java build tool",
})

-- Node.js project detection (package.json)
autocmd({ "BufEnter", "DirChanged" }, {
  group = project,
  pattern = { "*.js", "*.jsx", "*.ts", "*.tsx" },
  callback = function()
    local cwd = vim.fn.getcwd()
    
    if vim.fn.filereadable(cwd .. "/package.json") == 1 then
      vim.b.node_project = true
      
      -- Detect package manager
      if vim.fn.filereadable(cwd .. "/pnpm-lock.yaml") == 1 then
        vim.b.node_package_manager = "pnpm"
      elseif vim.fn.filereadable(cwd .. "/yarn.lock") == 1 then
        vim.b.node_package_manager = "yarn"
      else
        vim.b.node_package_manager = "npm"
      end
    end
  end,
  desc = "Detect Node.js project",
})

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- Performance Optimizations
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
local performance = augroup("Performance", { clear = true })

-- Disable some features for large files (>1MB)
autocmd("BufReadPre", {
  group = performance,
  pattern = "*",
  callback = function()
    local file_size = vim.fn.getfsize(vim.fn.expand("%"))
    
    if file_size > 1024 * 1024 then  -- 1MB
      vim.opt_local.syntax = "off"
      vim.opt_local.foldmethod = "manual"
      vim.opt_local.swapfile = false
      vim.opt_local.undofile = false
      vim.opt_local.loadplugins = false
      vim.notify("Large file detected. Some features disabled.", vim.log.levels.WARN)
    end
  end,
  desc = "Optimize for large files",
})

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- UI Enhancements
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
local ui = augroup("UI", { clear = true })

-- Show cursor line only in active window
autocmd({ "WinEnter", "BufEnter" }, {
  group = ui,
  callback = function()
    vim.opt_local.cursorline = true
  end,
  desc = "Enable cursorline in active window",
})

autocmd({ "WinLeave", "BufLeave" }, {
  group = ui,
  callback = function()
    vim.opt_local.cursorline = false
  end,
  desc = "Disable cursorline in inactive window",
})

-- Create missing directories when saving file
autocmd("BufWritePre", {
  group = augroup("CreateDirs", { clear = true }),
  callback = function(event)
    if event.match:match("^%w%w+://") then
      return
    end
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
  desc = "Create missing directories",
})