return {
  "danymat/neogen",
  event = "VeryLazy",
  opts = {
    snippet_engine = vim.g.vscode and nil or 'mini',
    languages = {
      python = {
        template = {
          annotation_convention = "google_docstrings",
        },
      },
    },
    placeholders_text = {
      ["description"] = "desc",
      ["tparam"] = "tparam",
      ["parameter"] = "param",
      ["return"] = "return",
      ["class"] = "class",
      ["throw"] = "throw",
      ["varargs"] = "varargs",
      ["type"] = "type",
      ["attribute"] = "attr",
      ["args"] = "args",
      ["kwargs"] = "kwargs",
    }
  },
  config = function(_, opts)

    local neogen = require("neogen")

    local map = require("utils").map

    neogen.setup(opts)

    map("n", "<leader>df", function()
      neogen.generate({ type = "func" })
    end, { desc = "Generate function annotations" })

    map("n", "<leader>dc", function()
      neogen.generate({ type = "class" })
    end, { desc = "Generate class annotations" })

    map("n", "<leader>dt", function()
      neogen.generate({ type = "type" })
    end, { desc = "Generate type annotations" })

    map("n", "<leader>dF", function()
      neogen.generate({type = "file" })
    end, { desc = "Generate file annotations" })
  end,
}
