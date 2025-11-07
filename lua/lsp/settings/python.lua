--[[
═══════════════════════════════════════════════════════════════════
  Python Configuration
  
  Settings for Python development with:
  - Pyright LSP
  - Black formatter
  - isort import sorting
  - Virtual environment detection
  - Debugging with debugpy
═══════════════════════════════════════════════════════════════════
--]]

local M = {}

M.settings = {
  python = {
    analysis = {
      typeCheckingMode = "basic", -- off, basic, strict
      autoSearchPaths = true,
      useLibraryCodeForTypes = true,
      diagnosticMode = "workspace", -- openFilesOnly, workspace
      inlayHints = {
        variableTypes = true,
        functionReturnTypes = true,
      },
      autoImportCompletions = true,
    },
  },
}

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- Virtual Environment Detection
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

M.find_virtualenv = function()
  local cwd = vim.fn.getcwd()
  local venv_paths = { ".venv", "venv", "env", ".env", "virtualenv" }
  
  for _, venv in ipairs(venv_paths) do
    local venv_python = cwd .. "/" .. venv .. "/bin/python"
    if vim.fn.executable(venv_python) == 1 then
      return venv_python
    end
  end
  
  -- Try poetry
  local poetry_env = vim.fn.trim(vim.fn.system("poetry env info -p 2>/dev/null"))
  if vim.v.shell_error == 0 and poetry_env ~= "" then
    local poetry_python = poetry_env .. "/bin/python"
    if vim.fn.executable(poetry_python) == 1 then
      return poetry_python
    end
  end
  
  -- Try conda
  local conda_prefix = os.getenv("CONDA_PREFIX")
  if conda_prefix then
    local conda_python = conda_prefix .. "/bin/python"
    if vim.fn.executable(conda_python) == 1 then
      return conda_python
    end
  end
  
  -- Fall back to system python
  return vim.fn.exepath("python3") or vim.fn.exepath("python")
end

M.setup_virtualenv = function()
  local venv_python = M.find_virtualenv()
  if venv_python then
    vim.g.python3_host_prog = venv_python
    vim.notify("Python virtualenv detected: " .. venv_python, vim.log.levels.INFO)
  end
end

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- Formatting with Black and isort
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

M.format_python = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local filename = vim.api.nvim_buf_get_name(bufnr)
  
  -- Run isort first (import sorting)
  if vim.fn.executable("isort") == 1 then
    vim.fn.system({ "isort", filename })
  end
  
  -- Then run black (code formatting)
  if vim.fn.executable("black") == 1 then
    vim.fn.system({ "black", "-q", filename })
  end
  
  -- Reload buffer
  vim.cmd("edit!")
  vim.notify("Python file formatted with isort & black", vim.log.levels.INFO)
end

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- Python Project Utilities
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

-- Run current Python file
M.run_python_file = function()
  local python = M.find_virtualenv()
  local file = vim.fn.expand("%:p")
  
  vim.cmd("ToggleTerm")
  vim.fn.chansend(vim.b.toggle_number, python .. " " .. file .. "\n")
end

-- Run pytest
M.run_pytest = function(args)
  local python = M.find_virtualenv()
  local cmd = python .. " -m pytest " .. (args or "")
  
  vim.cmd("ToggleTerm")
  vim.fn.chansend(vim.b.toggle_number, cmd .. "\n")
end

-- Install requirements
M.install_requirements = function()
  local python = M.find_virtualenv()
  local pip = vim.fn.fnamemodify(python, ":h") .. "/pip"
  
  vim.cmd("ToggleTerm")
  vim.fn.chansend(vim.b.toggle_number, pip .. " install -r requirements.txt\n")
end

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- Setup Python-specific keymaps and autocommands
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

M.setup_autocommands = function()
  local augroup = vim.api.nvim_create_augroup("PythonSettings", { clear = true })
  
  -- Detect virtualenv when entering Python buffer
  vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
    group = augroup,
    pattern = "*.py",
    callback = M.setup_virtualenv,
  })
  
  -- Auto-format on save (if formatters are installed)
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = augroup,
    pattern = "*.py",
    callback = function()
      -- Check if conform.nvim is available (it handles formatting)
      local conform_ok = pcall(require, "conform")
      if not conform_ok then
        -- Fallback to manual formatting
        if vim.fn.executable("black") == 1 or vim.fn.executable("isort") == 1 then
          M.format_python()
        end
      end
    end,
  })
end

M.setup_keymaps = function(bufnr)
  local opts = { buffer = bufnr, silent = true }
  
  vim.keymap.set("n", "<leader>pr", M.run_python_file, 
    vim.tbl_extend("force", opts, { desc = "Run Python file" }))
  vim.keymap.set("n", "<leader>pt", function() M.run_pytest() end, 
    vim.tbl_extend("force", opts, { desc = "Run pytest" }))
  vim.keymap.set("n", "<leader>pf", M.format_python, 
    vim.tbl_extend("force", opts, { desc = "Format with black/isort" }))
  vim.keymap.set("n", "<leader>pi", M.install_requirements, 
    vim.tbl_extend("force", opts, { desc = "Install requirements" }))
  
  -- Which-key group
  local wk_ok, wk = pcall(require, "which-key")
  if wk_ok then
    wk.register({
      ["<leader>p"] = { name = "+python" },
    })
  end
end

return M