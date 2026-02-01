--[[
═══════════════════════════════════════════════════════════════════
  Neovim Options & Settings
  
  Professional IDE-like defaults optimized for development
  Configured for: Java, JS/TS, Python, SQL, Docker workflows
═══════════════════════════════════════════════════════════════════
--]]

local opt = vim.opt
local g = vim.g

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- General Behavior
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
opt.mouse = "a"                  -- Enable mouse support in all modes
opt.clipboard = "unnamedplus"    -- Use system clipboard
opt.swapfile = false             -- No swap files (use Git/auto-save instead)
opt.backup = false               -- No backup files
opt.writebackup = false          -- No backup before overwriting file
opt.undofile = true              -- Persistent undo history
opt.undodir = vim.fn.stdpath("data") .. "/undo"
opt.updatetime = 250             -- Faster completion & diagnostics (default: 4000ms)
opt.timeoutlen = 300             -- Time to wait for mapped sequence (ms)
opt.hidden = true                -- Allow switching buffers without saving

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- UI & Appearance
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
opt.termguicolors = true         -- Enable 24-bit RGB colors
opt.number = true                -- Show absolute line numbers
opt.relativenumber = true        -- Show relative line numbers (for motion commands)
opt.cursorline = true            -- Highlight current line
opt.signcolumn = "yes"           -- Always show sign column (prevents text shifting)
opt.colorcolumn = "120"          -- Visual guide at 120 characters
opt.wrap = false                 -- Don't wrap long lines
opt.scrolloff = 8                -- Minimum lines to keep above/below cursor
opt.sidescrolloff = 8            -- Minimum columns to keep left/right of cursor
opt.pumheight = 10               -- Maximum items in popup menu
opt.pumblend = 10                -- Popup menu transparency (0-30)
opt.winblend = 0                 -- Floating window transparency
opt.laststatus = 3               -- Global statusline (matches lualine globalstatus)

-- Show invisible characters (like IntelliJ)
opt.list = true
opt.listchars = {
  tab = "→ ",
  trail = "·",
  nbsp = "␣",
  extends = "⟩",
  precedes = "⟨",
}

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- Indentation & Formatting
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
opt.expandtab = true             -- Convert tabs to spaces
opt.shiftwidth = 4               -- Spaces for indentation (>> and <<)
opt.tabstop = 4                  -- Spaces per tab character
opt.softtabstop = 4              -- Spaces when pressing <Tab>
opt.smartindent = true           -- Auto-indent new lines
opt.breakindent = true           -- Preserve indentation in wrapped lines
opt.shiftround = true            -- Round indent to multiple of shiftwidth

-- Language-specific indentation overrides are in lua/config/autocommands.lua
-- (using vim.opt_local for correct buffer-local behavior)

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- Search & Replace
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
opt.ignorecase = true            -- Case-insensitive search
opt.smartcase = true             -- Case-sensitive if uppercase present
opt.hlsearch = true              -- Highlight search results
opt.incsearch = true             -- Incremental search (show matches while typing)
opt.inccommand = "split"         -- Live preview for :substitute

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- Splitting & Windows
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
opt.splitbelow = true            -- Horizontal splits open below
opt.splitright = true            -- Vertical splits open to the right
opt.equalalways = false          -- Don't auto-resize splits

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- Completion & Wildmenu
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
opt.completeopt = { "menu", "menuone", "noselect" }
opt.wildmode = "longest:full,full"
opt.wildignore = {
  "*.o", "*.obj", "*.class", "*.pyc",
  "*/.git/*", "*/.hg/*", "*/.svn/*",
  "*/node_modules/*", "*/target/*", "*/build/*", "*/dist/*",
  "*.jar", "*.war", "*.ear",
}

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- Performance
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
opt.lazyredraw = false           -- Redraw during macros (set to true if slow)
opt.synmaxcol = 300              -- Don't syntax highlight long lines

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- File Handling
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
opt.encoding = "utf-8"
opt.fileencoding = "utf-8"
opt.autoread = true              -- Auto-reload files changed outside Vim
opt.confirm = true               -- Confirm before closing unsaved buffers

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- Folding (using Treesitter)
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldenable = false           -- Don't fold by default
opt.foldlevel = 99
opt.foldlevelstart = 99

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- Shell Configuration (zsh + Oh My Zsh)
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
opt.shell = vim.fn.executable("zsh") == 1 and "zsh" or "bash"

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- Global Variables
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
g.loaded_perl_provider = 0       -- Disable Perl provider
g.loaded_ruby_provider = 0       -- Disable Ruby provider

-- Python provider (use system or virtualenv)
-- Adjust paths if using specific Python versions via pyenv
if vim.fn.executable("python3") == 1 then
  g.python3_host_prog = vim.fn.exepath("python3")
end

-- Node.js provider (for coc.nvim alternatives if needed)
if vim.fn.executable("node") == 1 then
  g.node_host_prog = vim.fn.exepath("node")
end