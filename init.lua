-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Basic settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.termguicolors = true

-- Load config
local ok_opts = pcall(require, "config.options")
local ok_keys = pcall(require, "config.keymaps")
local ok_auto = pcall(require, "config.autocommands")

-- Setup plugins
require("lazy").setup({
    { import = "plugins.ui" },
    { import = "plugins.treesitter" },
    { import = "plugins.lsp" },
    { import = "plugins.cmp" },
    { import = "plugins.git" },
    { import = "plugins.dap" },
    { import = "plugins.misc" },
    { import = "plugins.go" },
}, {
    defaults = { lazy = false },
    install = { colorscheme = { "github_dark_default" } },
    checker = { enabled = false },
    performance = {
        rtp = {
            disabled_plugins = {
                "gzip", "matchit", "matchparen", "netrwPlugin",
                "tarPlugin", "tohtml", "tutor", "zipPlugin",
            },
        },
    },
})

-- Setup LSP after plugins load
vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
        pcall(require, "lsp.handlers")
        pcall(require, "lsp.servers")
    end,
})

