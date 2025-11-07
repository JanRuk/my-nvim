return {
  -- Colorscheme
  {
    "projekt0n/github-nvim-theme",
    priority = 1000,
    config = function()
      require("github-theme").setup({})
      vim.cmd("colorscheme github_dark_default")
    end,
  },
  
  -- Icons
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
  },
  
  -- File tree
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Toggle explorer" },
    },
    opts = {
      disable_netrw = true,
      hijack_netrw = true,
      view = { width = 35 },
    },
  },
  
  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        theme = "auto",
        globalstatus = true,
      },
    },
  },
  
  -- Bufferline
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    opts = {},
  },
  
  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>" },
    },
    opts = {},
  },
  
  -- Which-key
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
  },
  
  -- Indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },
  
  -- Terminal
  {
    "akinsho/toggleterm.nvim",
    cmd = "ToggleTerm",
    opts = {
      direction = "horizontal",
      size = 15,
    },
  },
  
  -- Notifications
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    opts = {},
  },
}