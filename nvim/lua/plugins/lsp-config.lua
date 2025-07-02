return {
  -- LSP Configuration
  -- https://github.com/neovim/nvim-lspconfig
  "neovim/nvim-lspconfig",
  event = "VeryLazy",
  dependencies = {
    -- LSP Management
    -- https://github.com/williamboman/mason.nvim
    { "williamboman/mason.nvim" },
    -- https://github.com/williamboman/mason-lspconfig.nvim
    { "williamboman/mason-lspconfig.nvim" },

    -- Auto-Install LSPs, linters, formatters, debuggers
    -- https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim
    { "WhoIsSethDaniel/mason-tool-installer.nvim" },

    -- Useful status updates for LSP
    -- https://github.com/j-hui/fidget.nvim
    { "j-hui/fidget.nvim", opts = {} },

    -- Additional lua configuration, makes nvim stuff amazing!
    -- https://github.com/folke/neodev.nvim
    -- { "folke/neodev.nvim", opts = {} },
  },
  config = function()
    require("mason").setup()
    require("mason-lspconfig").setup({
      -- Install these LSPs automatically
      ensure_installed = {
        "bashls",
        "cssls",
        "html",
        "gradle_ls",
        "groovyls",
        "lua_ls",
        "jsonls",
        -- "marksman",
        "quick_lint_js",
        "yamlls",
      },
      automatic_installation = true, -- Automatically install LSPs that are not installed
    })

    require("mason-tool-installer").setup({
      -- Install these linters, formatters, debuggers automatically
      ensure_installed = {
        -- "java-debug-adapter",
        -- "java-test",
        -- "rust_analyzer",
        -- "rustfmt",
        -- "clippy",
      },
      opts = {
        setup = {
          rust_analyzer = function()
            -- This is a workaround for the fact that rust-analyzer is not installed by mason-tool-installer
            -- and needs to be installed separately.
            -- You can install it using rustup: `rustup component add rust-analyzer-preview`
            return true
          end,
        },
      },
    })

    -- There is an issue with mason-tools-installer running with VeryLazy, since it triggers on VimEnter which has already occurred prior to this plugin loading so we need to call install explicitly
    -- https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim/issues/39
    vim.api.nvim_command("MasonToolsInstall")

    local lspconfig = require("lspconfig")

    local ok_cmp, cmp = pcall(require, "cmp")
    local capabilities
    if ok_cmp then
      cmp.setup({
        sources = {
          { name = "nvim_lsp" },
        },
      })
      capabilities = require("cmp_nvim_lsp").default_capabilities()
    end

    -- The nvim-cmp almost supports LSP's capabilities so You should advertise it to LSP servers..
    -- local capabilities = require("cmp_nvim_lsp").default_capabilities()

    -- An example for configuring `clangd` LSP to use nvim-cmp as a completion engine
    -- require("lspconfig").clangd.setup({
    --   capabilities = capabilities,
    --   ..., -- other lspconfig configs
    -- })
    local lsp_attach = function(client, bufnr)
      -- Create your keybindings here...
    end

    -- Call setup on each LSP server
    require("mason-lspconfig").setup_handlers({
      function(server_name)
        -- Don't call setup for JDTLS Java LSP because it will be setup from a separate config
        --
        if server_name ~= "jdtls" and server_name ~= "rust_analyzer" then
          lspconfig[server_name].setup({
            inlay_hints = {
              enabled = true, -- Enable inlay hints
            },
            -- attach = lsp_attach,
          })
        end
      end,
    })

    -- Setup JAVA LSP
    require("java").setup()
    lspconfig.jdtls.setup({
      settings = {
        java = {
          configuration = {
            runtimes = {
              {
                name = "jdk-23-oracle",
                path = "/usr/lib/jvm/jdk-23-oracle/bin/java",
                default = true,
              },
            },
          },
        },
      },
    })
    -- Lua LSP settings
    lspconfig.lua_ls.setup({
      settings = {
        Lua = {
          diagnostics = {
            -- Get the language server to recognize the `vim` global
            globals = { "vim" },
          },
        },
      },
    })

    -- lspconfig.rust_analyzer.setup({
    --   settings = {
    --     cargo = {
    --       features = "all", -- Enable all features for Rust projects
    --     },
    --     ["rust-analyzer"] = {
    --       checkOnSave = {
    --         command = "clippy", -- Use Clippy for checking Rust code
    --       },
    --     },
    --   },
    -- })
    -- Globally configure all LSP floating preview popups (like hover, signature help, etc)
    local open_floating_preview = vim.lsp.util.open_floating_preview
    function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
      opts = opts or {}
      opts.border = opts.border or "rounded" -- Set border to rounded
      return open_floating_preview(contents, syntax, opts, ...)
    end
  end,
}
