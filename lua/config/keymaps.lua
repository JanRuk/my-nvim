--[[
═══════════════════════════════════════════════════════════════════
  Keymaps & Shortcuts
  
  IntelliJ-inspired keybindings for professional workflows
  Leader key: <Space>
  Local leader: <,>
═══════════════════════════════════════════════════════════════════
--]]

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- General Mappings
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

-- Better escape (jk or kj to exit insert mode)
keymap("i", "jk", "<Esc>", opts)
keymap("i", "kj", "<Esc>", opts)

-- Save file
keymap("n", "<C-s>", ":w<CR>", opts)
keymap("i", "<C-s>", "<Esc>:w<CR>a", opts)

-- Quit
keymap("n", "<leader>q", ":q<CR>", { desc = "Quit" })
keymap("n", "<leader>Q", ":qa!<CR>", { desc = "Quit all without saving" })

-- Clear search highlighting
keymap("n", "<Esc>", ":noh<CR>", opts)

-- Select all
keymap("n", "<C-a>", "ggVG", opts)

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- Window Navigation (Ctrl + hjkl)
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
keymap("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
keymap("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
keymap("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
keymap("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- Window Resizing
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
keymap("n", "<C-Up>", ":resize +2<CR>", opts)
keymap("n", "<C-Down>", ":resize -2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- Buffer Navigation (like IntelliJ tabs)
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
keymap("n", "<S-l>", ":bnext<CR>", { desc = "Next buffer" })
keymap("n", "<S-h>", ":bprevious<CR>", { desc = "Previous buffer" })
keymap("n", "<leader>bd", ":bdelete<CR>", { desc = "Delete buffer" })
keymap("n", "<leader>bD", ":bdelete!<CR>", { desc = "Force delete buffer" })

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- Better Indenting (stay in visual mode)
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- Move Lines (Alt + j/k like IntelliJ)
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
keymap("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
keymap("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
keymap("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
keymap("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- Better Paste (don't override register)
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
keymap("v", "p", '"_dP', opts)

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- Split Management
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
keymap("n", "<leader>sv", ":vsplit<CR>", { desc = "Vertical split" })
keymap("n", "<leader>sh", ":split<CR>", { desc = "Horizontal split" })
keymap("n", "<leader>sc", "<C-w>c", { desc = "Close split" })
keymap("n", "<leader>so", "<C-w>o", { desc = "Close other splits" })

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- File Explorer (nvim-tree will override <leader>e)
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
keymap("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle file explorer" })

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- Telescope (fuzzy finder) - mapped to IntelliJ-like shortcuts
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- Files
keymap("n", "<leader>ff", ":Telescope find_files<CR>", { desc = "Find files" })
keymap("n", "<C-p>", ":Telescope find_files<CR>", { desc = "Find files" })
keymap("n", "<leader>fr", ":Telescope oldfiles<CR>", { desc = "Recent files" })

-- Text search
keymap("n", "<leader>fg", ":Telescope live_grep<CR>", { desc = "Live grep" })
keymap("n", "<leader>fw", ":Telescope grep_string<CR>", { desc = "Find word under cursor" })
keymap("n", "<C-S-f>", ":Telescope live_grep<CR>", { desc = "Find in files" })

-- Buffers
keymap("n", "<leader>fb", ":Telescope buffers<CR>", { desc = "Find buffers" })
keymap("n", "<leader><space>", ":Telescope buffers<CR>", { desc = "Find buffers" })

-- Help & commands
keymap("n", "<leader>fh", ":Telescope help_tags<CR>", { desc = "Help tags" })
keymap("n", "<leader>fc", ":Telescope commands<CR>", { desc = "Commands" })
keymap("n", "<leader>fk", ":Telescope keymaps<CR>", { desc = "Keymaps" })

-- Git
keymap("n", "<leader>gs", ":Telescope git_status<CR>", { desc = "Git status" })
keymap("n", "<leader>gc", ":Telescope git_commits<CR>", { desc = "Git commits" })
keymap("n", "<leader>gb", ":Telescope git_branches<CR>", { desc = "Git branches" })

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- LSP Keymaps (will be attached when LSP server starts)
-- These are placeholders - actual bindings set in lua/lsp/handlers.lua
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- gd           → Go to definition
-- gD           → Go to declaration
-- gi           → Go to implementation
-- gr           → Go to references
-- K            → Hover documentation
-- <leader>ca   → Code actions
-- <leader>rn   → Rename symbol
-- <leader>D    → Type definition
-- <leader>ds   → Document symbols
-- <leader>ws   → Workspace symbols
-- [d           → Previous diagnostic
-- ]d           → Next diagnostic
-- <leader>dl   → Show line diagnostics

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- Diagnostic Navigation
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
keymap("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
keymap("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
keymap("n", "<leader>dl", vim.diagnostic.open_float, { desc = "Line diagnostics" })
keymap("n", "<leader>dq", vim.diagnostic.setloclist, { desc = "Diagnostics to loclist" })

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- Terminal Toggle (toggleterm)
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
keymap("n", "<C-\\>", ":ToggleTerm<CR>", { desc = "Toggle terminal" })
keymap("t", "<C-\\>", "<C-\\><C-n>:ToggleTerm<CR>", { desc = "Toggle terminal" })
keymap("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- Quick Commands
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
keymap("n", "<leader>w", ":w<CR>", { desc = "Save" })
keymap("n", "<leader>x", ":x<CR>", { desc = "Save and quit" })
keymap("n", "<leader>nh", ":noh<CR>", { desc = "Clear highlights" })

-- Quickfix list navigation
keymap("n", "[q", ":cprev<CR>", { desc = "Previous quickfix" })
keymap("n", "]q", ":cnext<CR>", { desc = "Next quickfix" })
keymap("n", "<leader>qo", ":copen<CR>", { desc = "Open quickfix" })
keymap("n", "<leader>qc", ":cclose<CR>", { desc = "Close quickfix" })

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- Plugin-specific Keymaps (will be set in plugin configs)
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- Git (gitsigns):
--   ]c / [c     → Next/prev hunk
--   <leader>hs  → Stage hunk
--   <leader>hr  → Reset hunk
--   <leader>hp  → Preview hunk
--   <leader>hb  → Blame line

-- DAP (debugging):
--   <F5>        → Continue
--   <F10>       → Step over
--   <F11>       → Step into
--   <F12>       → Step out
--   <leader>db  → Toggle breakpoint
--   <leader>dB  → Conditional breakpoint
--   <leader>dr  → Open REPL

keymap("n", "<leader>tt", "<Cmd>ToggleTerm<CR>", { desc = "Toggle terminal" })
