--[[
═══════════════════════════════════════════════════════════════════
  Utility Functions
  
  Helper functions for common tasks
═══════════════════════════════════════════════════════════════════
--]]

local M = {}

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- Check if running inside a Git repository
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
M.is_git_repo = function()
  vim.fn.system("git rev-parse --is-inside-work-tree")
  return vim.v.shell_error == 0
end

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- Get Git branch name
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
M.get_git_branch = function()
  if not M.is_git_repo() then
    return ""
  end
  local branch = vim.fn.system("git branch --show-current 2> /dev/null | tr -d '\n'")
  return branch
end

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- Toggle between number and relativenumber
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
M.toggle_relativenumber = function()
  if vim.wo.relativenumber then
    vim.wo.relativenumber = false
    vim.notify("Relative numbers disabled", vim.log.levels.INFO)
  else
    vim.wo.relativenumber = true
    vim.notify("Relative numbers enabled", vim.log.levels.INFO)
  end
end

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- Quick Run Commands for different project types
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
M.quick_run = function()
  local ft = vim.bo.filetype
  local file = vim.fn.expand("%:p")
  
  if ft == "python" then
    vim.cmd("ToggleTerm")
    vim.fn.chansend(vim.b.toggle_number, "python3 " .. file .. "\n")
  elseif ft == "javascript" or ft == "typescript" then
    vim.cmd("ToggleTerm")
    vim.fn.chansend(vim.b.toggle_number, "node " .. file .. "\n")
  elseif ft == "java" then
    vim.notify("Use <leader>jt to run Java tests or build with Maven/Gradle", vim.log.levels.INFO)
  elseif ft == "lua" then
    vim.cmd("source %")
    vim.notify("Lua file sourced", vim.log.levels.INFO)
  else
    vim.notify("No quick run command for filetype: " .. ft, vim.log.levels.WARN)
  end
end

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- Reload Neovim configuration
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
M.reload_config = function()
  for name, _ in pairs(package.loaded) do
    if name:match("^config") or name:match("^plugins") or name:match("^lsp") then
      package.loaded[name] = nil
    end
  end
  
  dofile(vim.env.MYVIMRC)
  vim.notify("Configuration reloaded!", vim.log.levels.INFO)
end

return M