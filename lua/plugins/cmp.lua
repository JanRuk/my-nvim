--[[
═══════════════════════════════════════════════════════════════════
  Completion Configuration
  
  nvim-cmp with multiple sources and snippet support
═══════════════════════════════════════════════════════════════════
--]]

return {
  -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  -- Snippet Engine
  -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build = "make install_jsregexp",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local luasnip = require("luasnip")
      
      -- Load VSCode-style snippets
      require("luasnip.loaders.from_vscode").lazy_load()
      
      -- Custom snippets
      luasnip.add_snippets("java", {
        luasnip.snippet("sout", {
          luasnip.text_node("System.out.println("),
          luasnip.insert_node(1),
          luasnip.text_node(");"),
        }),
        luasnip.snippet("psvm", {
          luasnip.text_node("public static void main(String[] args) {"),
          luasnip.text_node({ "", "\t" }),
          luasnip.insert_node(1),
          luasnip.text_node({ "", "}" }),
        }),
      })
      
      luasnip.add_snippets("python", {
        luasnip.snippet("ifmain", {
          luasnip.text_node('if __name__ == "__main__":'),
          luasnip.text_node({ "", "\t" }),
          luasnip.insert_node(1),
        }),
        luasnip.snippet("defmain", {
          luasnip.text_node("def main():"),
          luasnip.text_node({ "", "\t" }),
          luasnip.insert_node(1),
          luasnip.text_node({ "", "", "" }),
          luasnip.text_node('if __name__ == "__main__":'),
          luasnip.text_node({ "", "\tmain()" }),
        }),
      })
      
      luasnip.add_snippets("typescript", {
        luasnip.snippet("cl", {
          luasnip.text_node("console.log("),
          luasnip.insert_node(1),
          luasnip.text_node(");"),
        }),
        luasnip.snippet("arrowfn", {
          luasnip.text_node("const "),
          luasnip.insert_node(1, "functionName"),
          luasnip.text_node(" = ("),
          luasnip.insert_node(2),
          luasnip.text_node(") => {"),
          luasnip.text_node({ "", "\t" }),
          luasnip.insert_node(3),
          luasnip.text_node({ "", "}" }),
        }),
      })
    end,
  },
  
  -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  -- Completion Engine
  -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",     -- LSP completion
      "hrsh7th/cmp-buffer",       -- Buffer completion
      "hrsh7th/cmp-path",         -- Path completion
      "hrsh7th/cmp-cmdline",      -- Command-line completion
      "saadparwaiz1/cmp_luasnip", -- Snippet completion
      "L3MON4D3/LuaSnip",         -- Snippet engine
      "onsails/lspkind.nvim",     -- VSCode-like pictograms
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")
      
      -- Helper function to check if we can jump forward
      local has_words_before = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end
      
      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        
        window = {
          completion = cmp.config.window.bordered({
            border = "rounded",
            winhighlight = "Normal:Normal,FloatBorder:BorderBG,CursorLine:PmenuSel,Search:None",
          }),
          documentation = cmp.config.window.bordered({
            border = "rounded",
            winhighlight = "Normal:Normal,FloatBorder:BorderBG,CursorLine:PmenuSel,Search:None",
          }),
        },
        
        mapping = cmp.mapping.preset.insert({
          -- Scroll documentation
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          
          -- Trigger completion
          ["<C-Space>"] = cmp.mapping.complete(),
          
          -- Close completion
          ["<C-e>"] = cmp.mapping.abort(),
          
          -- Confirm completion (Enter)
          ["<CR>"] = cmp.mapping.confirm({ select = false }),
          
          -- Navigate completion menu
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          
          -- Tab/Shift-Tab for completion and snippets
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { "i", "s" }),
          
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        
        sources = cmp.config.sources({
          { name = "nvim_lsp", priority = 1000 },
          { name = "luasnip", priority = 750 },
          { name = "buffer", priority = 500 },
          { name = "path", priority = 250 },
        }),
        
        formatting = {
          format = lspkind.cmp_format({
            mode = "symbol_text",
            maxwidth = 50,
            ellipsis_char = "...",
            show_labelDetails = true,
            before = function(entry, vim_item)
              -- Source name
              vim_item.menu = ({
                nvim_lsp = "[LSP]",
                luasnip = "[Snippet]",
                buffer = "[Buffer]",
                path = "[Path]",
              })[entry.source.name]
              return vim_item
            end,
          }),
        },
        
        experimental = {
          ghost_text = {
            hl_group = "CmpGhostText",
          },
        },
      })
      
      -- `/` cmdline completion
      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })
      
      -- `:` cmdline completion
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline" },
        }),
      })
    end,
  },
  
  -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  -- Auto Pairs
  -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    dependencies = { "hrsh7th/nvim-cmp" },
    config = function()
      local autopairs = require("nvim-autopairs")
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      
      autopairs.setup({
        check_ts = true,
        ts_config = {
          lua = { "string" },
          javascript = { "template_string" },
          java = false,
        },
        disable_filetype = { "TelescopePrompt", "vim" },
        fast_wrap = {
          map = "<M-e>",
          chars = { "{", "[", "(", '"', "'" },
          pattern = [=[[%'%"%)%>%]%)%}%,]]=],
          end_key = "$",
          keys = "qwertyuiopzxcvbnmasdfghjkl",
          check_comma = true,
          highlight = "Search",
          highlight_grey = "Comment",
        },
      })
      
      -- Integrate with nvim-cmp
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },
  
  -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  -- VSCode-like Pictograms
  -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  {
    "onsails/lspkind.nvim",
    lazy = true,
    opts = {
      mode = "symbol_text",
      preset = "codicons",
      symbol_map = {
        Text = "󰉿",
        Method = "󰆧",
        Function = "󰊕",
        Constructor = "",
        Field = "󰜢",
        Variable = "󰀫",
        Class = "󰠱",
        Interface = "",
        Module = "",
        Property = "󰜢",
        Unit = "󰑭",
        Value = "󰎠",
        Enum = "",
        Keyword = "󰌋",
        Snippet = "",
        Color = "󰏘",
        File = "󰈙",
        Reference = "󰈇",
        Folder = "󰉋",
        EnumMember = "",
        Constant = "󰏿",
        Struct = "󰙅",
        Event = "",
        Operator = "󰆕",
        TypeParameter = "",
      },
    },
  },
}