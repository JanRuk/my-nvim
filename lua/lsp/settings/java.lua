--[[
═══════════════════════════════════════════════════════════════════
  Java LSP Configuration (jdtls)
  
  Advanced Java support with:
  - Eclipse JDT Language Server
  - Maven/Gradle integration
  - Debugging support
  - Spring Boot awareness
═══════════════════════════════════════════════════════════════════
--]]

local M = {}

M.setup = function()
  local jdtls_ok, jdtls = pcall(require, "jdtls")
  if not jdtls_ok then
    vim.notify("jdtls not found. Please install mfussenegger/nvim-jdtls", vim.log.levels.ERROR)
    return
  end
  
  local handlers = require("lsp.handlers")
  
  -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  -- Paths and Directories
  -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  
  -- Get JDTLS installation path (installed via Mason)
  local mason_registry = require("mason-registry")
  local jdtls_install = mason_registry.get_package("jdtls"):get_install_path()
  
  -- Determine OS for jdtls config
  local os_config = "linux"
  if vim.fn.has("mac") == 1 then
    os_config = "mac"
  elseif vim.fn.has("win32") == 1 then
    os_config = "win"
  end
  
  -- JDTLS paths
  local jdtls_bin = jdtls_install .. "/bin/jdtls"
  local jdtls_launcher = vim.fn.glob(jdtls_install .. "/plugins/org.eclipse.equinox.launcher_*.jar")
  local jdtls_config = jdtls_install .. "/config_" .. os_config
  
  -- Java runtime (uses SDKMAN or system Java)
  -- SDKMAN typically installs to ~/.sdkman/candidates/java/
  local java_home = os.getenv("JAVA_HOME")
  if not java_home then
    -- Try to find Java via 'java' command
    local java_cmd = vim.fn.exepath("java")
    if java_cmd ~= "" then
      java_home = vim.fn.fnamemodify(java_cmd, ":h:h")
    else
      vim.notify("JAVA_HOME not set and java not found in PATH", vim.log.levels.WARN)
      return
    end
  end
  
  -- Workspace directory (per-project)
  local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
  local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. project_name
  
  -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  -- Bundles (for debugging and testing)
  -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  
  local bundles = {}
  
  -- Java Debug Adapter
  local java_debug_path = mason_registry.get_package("java-debug-adapter"):get_install_path()
  local java_debug_jar = vim.fn.glob(java_debug_path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar", true)
  if java_debug_jar ~= "" then
    table.insert(bundles, java_debug_jar)
  end
  
  -- Java Test Runner
  local java_test_path = mason_registry.get_package("java-test"):get_install_path()
  vim.list_extend(bundles, vim.split(vim.fn.glob(java_test_path .. "/extension/server/*.jar", true), "\n"))
  
  -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  -- Extended Capabilities
  -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  
  local extendedClientCapabilities = jdtls.extendedClientCapabilities
  extendedClientCapabilities.resolveAdditionalTextEditsSupport = true
  
  -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  -- JDTLS Configuration
  -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  
  local config = {
    cmd = {
      java_home .. "/bin/java",
      "-Declipse.application=org.eclipse.jdt.ls.core.id1",
      "-Dosgi.bundles.defaultStartLevel=4",
      "-Declipse.product=org.eclipse.jdt.ls.core.product",
      "-Dlog.protocol=true",
      "-Dlog.level=ALL",
      "-Xms1g",
      "-Xmx2G",
      "--add-modules=ALL-SYSTEM",
      "--add-opens", "java.base/java.util=ALL-UNNAMED",
      "--add-opens", "java.base/java.lang=ALL-UNNAMED",
      "-jar", jdtls_launcher,
      "-configuration", jdtls_config,
      "-data", workspace_dir,
    },
    
    root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }),
    
    settings = {
      java = {
        eclipse = {
          downloadSources = true,
        },
        configuration = {
          updateBuildConfiguration = "interactive",
          -- Multiple Java runtime support (if using SDKMAN with multiple JDKs)
          runtimes = {
            {
              name = "JavaSE-11",
              path = os.getenv("HOME") .. "/.sdkman/candidates/java/11.0.23-tem",
              default = false,
            },
            {
              name = "JavaSE-17",
              path = os.getenv("HOME") .. "/.sdkman/candidates/java/17.0.11-tem",
              default = true,
            },
            {
              name = "JavaSE-21",
              path = os.getenv("HOME") .. "/.sdkman/candidates/java/21.0.3-tem",
            },
          },
        },
        maven = {
          downloadSources = true,
        },
        implementationsCodeLens = {
          enabled = true,
        },
        referencesCodeLens = {
          enabled = true,
        },
        references = {
          includeDecompiledSources = true,
        },
        format = {
          enabled = true,
          settings = {
            url = vim.fn.stdpath("config") .. "/lang-settings/java-google-style.xml",
            profile = "GoogleStyle",
          },
        },
        signatureHelp = { enabled = true },
        contentProvider = { preferred = "fernflower" },
        completion = {
          favoriteStaticMembers = {
            "org.junit.Assert.*",
            "org.junit.Assume.*",
            "org.junit.jupiter.api.Assertions.*",
            "org.junit.jupiter.api.Assumptions.*",
            "org.junit.jupiter.api.DynamicContainer.*",
            "org.junit.jupiter.api.DynamicTest.*",
            "org.mockito.Mockito.*",
            "org.mockito.ArgumentMatchers.*",
            "org.mockito.Answers.*",
          },
          filteredTypes = {
            "com.sun.*",
            "io.micrometer.shaded.*",
            "java.awt.*",
            "jdk.*",
            "sun.*",
          },
        },
        sources = {
          organizeImports = {
            starThreshold = 9999,
            staticStarThreshold = 9999,
          },
        },
        codeGeneration = {
          toString = {
            template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
          },
          useBlocks = true,
        },
      },
    },
    
    flags = {
      allow_incremental_sync = true,
      server_side_fuzzy_completion = true,
    },
    
    init_options = {
      bundles = bundles,
      extendedClientCapabilities = extendedClientCapabilities,
    },
    
    capabilities = handlers.capabilities(),
    
    on_attach = function(client, bufnr)
      -- Default LSP keymaps
      handlers.on_attach(client, bufnr)
      
      -- Java-specific keymaps
      local opts = { buffer = bufnr, silent = true }
      
      -- Code actions
      vim.keymap.set("n", "<leader>jo", "<cmd>lua require('jdtls').organize_imports()<CR>", 
        vim.tbl_extend("force", opts, { desc = "Organize imports" }))
      vim.keymap.set("n", "<leader>jv", "<cmd>lua require('jdtls').extract_variable()<CR>", 
        vim.tbl_extend("force", opts, { desc = "Extract variable" }))
      vim.keymap.set("v", "<leader>jv", "<Esc><cmd>lua require('jdtls').extract_variable(true)<CR>", 
        vim.tbl_extend("force", opts, { desc = "Extract variable" }))
      vim.keymap.set("n", "<leader>jc", "<cmd>lua require('jdtls').extract_constant()<CR>", 
        vim.tbl_extend("force", opts, { desc = "Extract constant" }))
      vim.keymap.set("v", "<leader>jc", "<Esc><cmd>lua require('jdtls').extract_constant(true)<CR>", 
        vim.tbl_extend("force", opts, { desc = "Extract constant" }))
      vim.keymap.set("v", "<leader>jm", "<Esc><cmd>lua require('jdtls').extract_method(true)<CR>", 
        vim.tbl_extend("force", opts, { desc = "Extract method" }))
      
      -- Testing
      vim.keymap.set("n", "<leader>jt", "<cmd>lua require('jdtls').test_class()<CR>", 
        vim.tbl_extend("force", opts, { desc = "Test class" }))
      vim.keymap.set("n", "<leader>jn", "<cmd>lua require('jdtls').test_nearest_method()<CR>", 
        vim.tbl_extend("force", opts, { desc = "Test nearest method" }))
      
      -- DAP setup for Java
      jdtls.setup_dap({ hotcodereplace = "auto" })
      require("jdtls.dap").setup_dap_main_class_configs()
      
      -- Which-key group registration
      local wk_ok, wk = pcall(require, "which-key")
      if wk_ok then
        wk.register({
          ["<leader>j"] = { name = "+java" },
        })
      end
    end,
  }
  
  -- Start or attach jdtls
  jdtls.start_or_attach(config)
end

return M