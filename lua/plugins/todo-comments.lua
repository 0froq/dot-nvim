return {
  "folke/todo-comments.nvim",
  event = { "BufReadPost", "BufNewFile" },
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    signs = false,
    highlight = { keyword = "bg", after = "bg" },
    keywords = {
      FIX = { color = "#CB7676" },
      TODO = { color = "#6394BF" },
      HACK = { color = "#EFAF8E" },
      WARN = { color = "#E6CC77" },
      PERF = { color = "#AE95C7" },
      NOTE = { color = "#5DA9A7" },
      TEST = { color = "#80A665" }
    }
  },
}

