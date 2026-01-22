return {
  "ThePrimeagen/refactoring.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  lazy = false,
  opts = {
    prompt_func_return_type = {
        go = true,
        java = true,

        cpp = true,
        c = true,
        h = true,
        hpp = true,
        cxx = true,
    },
    prompt_func_param_type = {
        go = true,
        java = true,

        cpp = true,
        c = true,
        h = true,
        hpp = true,
        cxx = true,
    },
  },
  config = function(_, opts)
    local Refactoring = require("refactoring")

    local map = require("utils").map

    Refactoring.setup(opts)

    map("x", "<leader>re", ":Refactor extract ", "Extract")
    map("x", "<leader>rF", ":Refactor extract_to_file ", "Extract to file")
    map("x", "<leader>rv", ":Refactor extract_var ", "Extract variable")
    map({ "n", "x" }, "<leader>iv", ":Refactor inline_var<cr>", "Inline variable")
    map("n", "<leader>if", ":Refactor inline_func<cr>", "Inline function")
    map("n", "<leader>rb", ":Refactor extract_block<cr>", "Extract block")
    map("n", "<leader>rB", ":Refactor extract_block_to_file", "Extract block to file")
  end,
}
