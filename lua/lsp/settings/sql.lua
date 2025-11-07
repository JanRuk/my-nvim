--[[
═══════════════════════════════════════════════════════════════════
  SQL Configuration
  
  Settings for SQL development with:
  - sqls LSP
  - Database connection management
  - Query execution
═══════════════════════════════════════════════════════════════════
--]]

local M = {}

M.settings = {
  sqls = {
    connections = {
      -- MySQL example
      {
        driver = "mysql",
        dataSourceName = "user:password@tcp(localhost:3306)/dbname",
        -- Or use environment variable:
        -- dataSourceName = os.getenv("MYSQL_DSN"),
      },
      -- PostgreSQL example
      {
        driver = "postgresql",
        dataSourceName = "host=localhost port=5432 user=postgres password=password dbname=mydb sslmode=disable",
        -- Or use environment variable:
        -- dataSourceName = os.getenv("POSTGRES_DSN"),
      },
      -- Add more connections as needed
    },
  },
}

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- SQL Utilities
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

-- Load connection config from file
M.load_connections = function()
  local config_file = vim.fn.stdpath("config") .. "/sql-connections.json"
  
  if vim.fn.filereadable(config_file) == 1 then
    local ok, connections = pcall(vim.fn.json_decode, vim.fn.readfile(config_file))
    if ok and connections then
      M.settings.sqls.connections = connections
      vim.notify("Loaded SQL connections from config", vim.log.levels.INFO)
      return connections
    end
  end
  
  return M.settings.sqls.connections
end

-- Execute SQL query in current buffer/selection
M.execute_query = function()
  vim.cmd("SqlsExecuteQuery")
end

-- Switch database connection
M.switch_connection = function()
  vim.cmd("SqlsSwitchConnection")
end

-- Show database structure
M.show_databases = function()
  vim.cmd("SqlsShowDatabases")
end

M.show_tables = function()
  vim.cmd("SqlsShowTables")
end

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- Setup SQL-specific keymaps
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

M.setup_keymaps = function(bufnr)
  local opts = { buffer = bufnr, silent = true }
  
  vim.keymap.set("n", "<leader>se", M.execute_query, 
    vim.tbl_extend("force", opts, { desc = "Execute SQL query" }))
  vim.keymap.set("v", "<leader>se", M.execute_query, 
    vim.tbl_extend("force", opts, { desc = "Execute SQL selection" }))
  vim.keymap.set("n", "<leader>sc", M.switch_connection, 
    vim.tbl_extend("force", opts, { desc = "Switch SQL connection" }))
  vim.keymap.set("n", "<leader>sd", M.show_databases, 
    vim.tbl_extend("force", opts, { desc = "Show databases" }))
  vim.keymap.set("n", "<leader>st", M.show_tables, 
    vim.tbl_extend("force", opts, { desc = "Show tables" }))
  
  -- Which-key group
  local wk_ok, wk = pcall(require, "which-key")
  if wk_ok then
    wk.register({
      ["<leader>s"] = { name = "+sql" },
    })
  end
end

-- Load connections on setup
M.load_connections()

return M