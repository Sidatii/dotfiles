return {
  {
    "mrcjkb/rustaceanvim",
    version = "^6",
    lazy = false,
    config = function()
      local mason_registry = require("mason-registry")
      local codelldb = mason_registry.get_package("codelldb")
      local extension_path = codelldb:get_install_path() .. "/extension/"
      local codelldb_path = extension_path .. "adapter/codelldb"
      local liblldb_path = extension_path .. "lldb/lib/liblldb.so"

      vim.g.rustaceanvim = {
        server = {
          on_attach = function(client, bufnr)
            vim.diagnostic.config({
              virtual_text = {
                prefix = "", -- Could be '●', '▎', 'x'
                spacing = 4,
                size = 6,
              },
              signs = true,
              underline = true,
              update_in_insert = false,
            })
            -- Keymaps for Rust actions (optional)
            local opts = { noremap = true, silent = true, buffer = bufnr }
            vim.keymap.set("n", "<leader>rr", "<cmd>RustRun<CR>", opts)
            vim.keymap.set("n", "<leader>rt", "<cmd>RustTest<CR>", opts)
          end,
          settings = {
            ["rust-analyzer"] = {
              cargo = { allFeatures = true },
              checkOnSave = { command = "clippy" },
              inlay_hints = { enable = true },
              -- inlayHints = { enable = true, typeHints = true, parameterHints = true },
            },
          },
        },
        dap = {
          adapter = (function()
            local ok, rustaceanvim = pcall(require, "rustaceanvim")
            if ok and rustaceanvim.get_codelldb_adapter then
              return rustaceanvim.get_codelldb_adapter(codelldb_path, liblldb_path)
            end
            return nil
          end)(),
        },
      }
    end,
    -- vim.api.nvim_create_autocmd("BufWritePre", {
    --   pattern = "*.rs",
    --   callback = function()
    --     vim.lsp.buf.format({ async = false })
    --   end,
    -- }),
    ft = "rust",
    -- config = function()
    --   local mason_registry = require("mason-registry")
    --   local codelldb = mason_registry.get_package("codelldb")
    --   local extension_path = codelldb:get_install_path() .. "/extension/"
    --   local codelldb_path = extension_path .. "adapter/codelldb"
    --   -- Use .so for Linux
    --   local liblldb_path = extension_path .. "lldb/lib/liblldb.so"
    --   local cfg = require("rustaceanvim.config")
    --
    --   vim.g.rustaceanvim = {
    --     dap = {
    --       adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
    --     },
    --   }
    -- end,
  },
  {
    "rust-lang/rust.vim",
    ft = "rust",
    init = function()
      vim.g.rustfmt_autosave = 1 -- handled in ftplugin/rust.lua
    end,
  },
  -- {
  --   "saecki/crates.nvim",
  --   ft = { "toml" },
  --   config = function()
  --     require("crates").setup({
  --       completion = {
  --         cmp = {
  --           enabled = true,
  --         },
  --       },
  --     })
  --     require("cmp").setup.buffer({
  --       sources = { { name = "crates" } },
  --     })
  --   end,
  -- },
}
