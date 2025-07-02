-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
-- vim.g.vim_markdown_toc_autofit = 1
-- vim.g.vim_markdown_folding_disabled = 1
-- vim.g.vim_markdown_conceal = 2
-- vim.g.vim_markdown_conceal_code_blocks = 0
--
-- -- Bullets.vim for better list/checkbox highlighting
-- vim.g.bullets_checkbox_markers = " x"
-- vim.o.conceallevel = 1
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.conceallevel = 2
  end,
})
