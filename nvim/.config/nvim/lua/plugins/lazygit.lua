return {
    "kdheepak/lazygit.nvim",
    command = "LazyGit",
    -- optional for floating window border decoration
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    config = function()
        require("telescope").load_extension("lazygit")
    end,
}
