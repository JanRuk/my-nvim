--[[
═══════════════════════════════════════════════════════════════════
  TypeScript/JavaScript Configuration
  
  Additional settings for modern JS/TS development
  - React/Angular support
  - ESLint integration
  - Prettier formatting
═══════════════════════════════════════════════════════════════════
--]]

local M = {}

M.settings = {
  -- TypeScript server settings
  typescript = {
    updateImportsOnFileMove = {
      enabled = "always",
    },
    suggest = {
      completeFunctionCalls = true,
    },
    inlayHints = {
      includeInlayParameterNameHints = "all",
      includeInlayParameterNameHintsWhenArgumentMatchesName = false,
      includeInlayFunctionParameterTypeHints = true,
      includeInlayVariableTypeHints = true,
      includeInlayPropertyDeclarationTypeHints = true,
      includeInlayFunctionLikeReturnTypeHints = true,
      includeInlayEnumMemberValueHints = true,
    },
  },
  
  javascript = {
    updateImportsOnFileMove = {
      enabled = "always",
    },
    suggest = {
      completeFunctionCalls = true,
    },
    inlayHints = {
      includeInlayParameterNameHints = "all",
      includeInlayParameterNameHintsWhenArgumentMatchesName = false,
      includeInlayFunctionParameterTypeHints = true,
      includeInlayVariableTypeHints = true,
      includeInlayPropertyDeclarationTypeHints = true,
      includeInlayFunctionLikeReturnTypeHints = true,
      includeInlayEnumMemberValueHints = true,
    },
  },
}

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- Additional utilities for JS/TS projects
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

-- Detect package manager (npm, yarn, pnpm)
M.detect_package_manager = function()
  local cwd = vim.fn.getcwd()
  
  if vim.fn.filereadable(cwd .. "/pnpm-lock.yaml") == 1 then
    return "pnpm"
  elseif vim.fn.filereadable(cwd .. "/yarn.lock") == 1 then
    return "yarn"
  elseif vim.fn.filereadable(cwd .. "/package-lock.json") == 1 then
    return "npm"
  end
  
  return "npm" -- default
end

-- Get npm scripts from package.json
M.get_npm_scripts = function()
  local cwd = vim.fn.getcwd()
  local package_json = cwd .. "/package.json"
  
  if vim.fn.filereadable(package_json) == 0 then
    return {}
  end
  
  local ok, decoded = pcall(vim.fn.json_decode, vim.fn.readfile(package_json))
  if not ok or not decoded.scripts then
    return {}
  end
  
  return decoded.scripts
end

-- Run npm script
M.run_npm_script = function(script_name)
  local pm = M.detect_package_manager()
  local cmd = string.format("%s run %s", pm, script_name)
  
  vim.cmd("ToggleTerm")
  vim.fn.chansend(vim.b.toggle_number, cmd .. "\n")
end

-- Setup autocommands for JS/TS files
M.setup_autocommands = function()
  local augroup = vim.api.nvim_create_augroup("TypeScriptSettings", { clear = true })
  
  -- Auto-format on save (if not using conform.nvim)
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = augroup,
    pattern = { "*.ts", "*.tsx", "*.js", "*.jsx" },
    callback = function()
      -- Only if LSP is attached
      local clients = vim.lsp.get_active_clients({ bufnr = 0 })
      if #clients > 0 then
        vim.lsp.buf.format({ async = false })
      end
    end,
  })
  
  -- Organize imports on save
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = augroup,
    pattern = { "*.ts", "*.tsx" },
    callback = function()
      vim.lsp.buf.code_action({
        context = {
          only = { "source.organizeImports" },
        },
        apply = true,
      })
    end,
  })
end

return M