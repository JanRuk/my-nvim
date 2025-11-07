--[[
═══════════════════════════════════════════════════════════════════
  Plugin Manager Setup
  
  Modular plugin configuration using lazy.nvim
  Plugins organized by functionality in separate files
═══════════════════════════════════════════════════════════════════
--]]

-- Bootstrap lazy.nvim (already done in init.lua, but checking)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.notify("lazy.nvim not found. Please restart Neovim.", vim.log.levels.ERROR)
  return
end

-- Setup lazy.nvim with modular plugin specs
require("lazy").setup({
  -- Load all plugin modules
  { import = "plugins.ui" },         -- UI/UX plugins
  { import = "plugins.treesitter" }, -- Syntax highlighting
  { import = "plugins.lsp" },        -- LSP & Mason
  { import = "plugins.cmp" },        -- Completion
  { import = "plugins.git" },        -- Git integration
  { import = "plugins.dap" },        -- Debugging
  { import = "plugins.misc" },       -- Miscellaneous utilities
}, {
  -- Lazy.nvim configuration
  defaults = {
    lazy = false, -- Don't lazy-load by default (we control it explicitly)
    version = false, -- Use latest commit unless version specified
  },
  install = {
    missing = true,
    colorscheme = { "github_dark_default", "onedark" }, -- Fallback colorschemes
  },
  checker = {
    enabled = true,  -- Check for plugin updates
    notify = false,  -- Don't notify about updates
    frequency = 3600, -- Check once per hour
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
  ui = {
    border = "rounded",
    icons = {
      cmd = "⌘",
      config = "🛠",
      event = "📅",
      ft = "📂",
      init = "⚙",
      keys = "🗝",
      plugin = "🔌",
      runtime = "💻",
      source = "📄",
      start = "🚀",
      task = "📌",
      lazy = "💤 ",
    },
  },
})