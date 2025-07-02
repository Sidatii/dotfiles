return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = { "OXY2DEV/markview.nvim" },
  opts = {
    ensure_installed = {
      "bash",
      "html",
      "javascript",
      "typescript",
      "toml",
      "json",
      "lua",
      "java",
      "rust",
      "markdown",
      "markdown_inline",
      "python",
      "query",
      "regex",
      "vim",
      "yaml",
    },
  },
}
