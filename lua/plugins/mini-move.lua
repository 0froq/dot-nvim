return {
  "nvim-mini/mini.move",
  version = false,
  lazy = false,
  opts = {
    mappings = {
      left = "<",
      right = ">",
      down = "J",
      up = "K",
      line_left = "g<",
      line_right = "g>",
      line_down = "gJ",
      line_up = "gK",
    }
  },
  config = function(_, opts)

    local MiniMove = require("mini.move")

    local map = require("utils").map
    local vscode_action = require("utils").vscode_action

    MiniMove.setup(opts)
  end
}
