-- since this is just an example spec, don't actually load anything here and return an empty spec
-- stylua: ignore
if true then return {} end

-- every spec file under the "plugins" directory will be loaded automatically by lazy.nvim
--
-- In your plugin files, you can:
-- * add extra plugins
-- * disable/enabled LazyVim plugins
-- * override the configuration of LazyVim plugins
return {
  -- add gruvbox
  --  { "ellisonleao/gruvbox.nvim" },

  -- Configure LazyVim to load gruvbox
  -- {
  --   "LazyVim/LazyVim",
  --   opts = {
  --     colorscheme = "gruvbox",
  --   },
  -- },

  -- change trouble config
  {
    "folke/trouble.nvim",
    -- opts will be merged with the parent spec
    opts = { use_diagnostic_signs = true },
  },

  -- disable trouble
  { "folke/trouble.nvim", enabled = false },

  -- change some telescope options and a keymap to browse plugin files
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      -- add a keymap to browse plugin files
      -- stylua: ignore
      {
        "<leader>fp",
        function() require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root }) end,
        desc = "Find Plugin File",
      },
    },
    -- change some options
    opts = {
      defaults = {
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        winblend = 0,
      },
    },
  },

  {
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
      { "folke/neodev.nvim", opts = {} },
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
          "jdtls",
          "rust-analyzer",
          "jsonls",
          "lemminx",
          "marksman",
          "quick_lint_js",
          "yamlls",
        },
      })

      require("mason-tool-installer").setup({
        -- Install these linters, formatters, debuggers automatically
        ensure_installed = {
          "java-debug-adapter",
          "java-test",
        },
      })

      -- There is an issue with mason-tools-installer running with VeryLazy, since it triggers on VimEnter which has already occurred prior to this plugin loading so we need to call install explicitly
      -- https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim/issues/39
      vim.api.nvim_command("MasonToolsInstall")

      local lspconfig = require("lspconfig")
      local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()
      local lsp_attach = function(client, bufnr)
        -- Create your keybindings here...
      end

      -- Call setup on each LSP server
      require("mason-lspconfig").setup_handlers({
        function(server_name)
          -- Don't call setup for JDTLS Java LSP because it will be setup from a separate config
          if server_name ~= "jdtls" then
            lspconfig[server_name].setup({
              on_attach = lsp_attach,
              capabilities = lsp_capabilities,
            })
          end
        end,
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

      -- Globally configure all LSP floating preview popups (like hover, signature help, etc)
      local open_floating_preview = vim.lsp.util.open_floating_preview
      function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
        opts = opts or {}
        opts.border = opts.border or "rounded" -- Set border to rounded
        return open_floating_preview(contents, syntax, opts, ...)
      end
    end,
  },
  -- for typescript, LazyVim also includes extra specs to properly setup lspconfig,
  -- treesitter, mason and typescript.nvim. So instead of the above, you can use:
  { import = "lazyvim.plugins.extras.lang.typescript" },

  -- add more treesitter parsers
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "html",
        "javascript",
        "json",
        "lua",
        "java",
        "rust",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "tsx",
        "typescript",
        "vim",
        "yaml",
      },
    },

    -- since `vim.tbl_deep_extend`, can only merge tables and not lists, the code above
    -- would overwrite `ensure_installed` with the new value.
    -- If you'd rather extend the default config, use the code below instead:
    {
      "nvim-treesitter/nvim-treesitter",
      opts = function(_, opts)
        -- add tsx and treesitter
        vim.list_extend(opts.ensure_installed, {
          "java",
          "rust",
        })
      end,
    },

    -- the opts function can also be used to change the default opts:
    {
      "nvim-lualine/lualine.nvim",
      event = "VeryLazy",
      opts = function(_, opts)
        table.insert(opts.sections.lualine_x, {
          function()
            return "😄"
          end,
        })
      end,
    },

    -- or you can return new options to override all the defaults
    {
      "nvim-lualine/lualine.nvim",
      event = "VeryLazy",
      opts = function()
        return {
          --[[add your custom lualine config here]]
        }
      end,
    },

    -- use mini.starter instead of alpha
    { import = "lazyvim.plugins.extras.ui.mini-starter" },

    -- add jsonls and schemastore packages, and setup treesitter for json, json5 and jsonc
    { import = "lazyvim.plugins.extras.lang.json" },

    -- add any tools you want to have installed below
    {
      "williamboman/mason.nvim",
      opts = {
        ensure_installed = {
          "stylua",
          "jdtls",
          "shellcheck",
          "shfmt",
          "flake8",
        },
      },
    },
  },
}
