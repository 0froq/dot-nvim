if vim.g.vscode then
  return {}
end
return {
  'nvim-mini/mini.diff',
  version = false,
  lazy = false,
  config = function()
    local MiniDiff = require('mini.diff')

    MiniDiff.setup({
      view = {
        style = 'sign',
        signs = {
          add = '┃',
          change = '┃',
          delete = '',
        },
      },
      -- mappings = {
      --   apply = "<leader>hs",
      --   textobject = "h"
      -- },
      source = MiniDiff.gen_source.save(),
    })
  end,
}
