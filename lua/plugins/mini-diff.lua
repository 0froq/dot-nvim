if vim.g.vscode then
  return {}
end

return {
  'nvim-mini/mini.diff',
  version = false,
  event = 'BufReadPre',
  opts = function()
    local MiniDiff = require('mini.diff')

    return {
      view = {
        style = 'sign',
        signs = {
          add = '┃',
          change = '┃',
          delete = '',
        },
      },
      mappings = {
        apply = '',
        reset = '',
        textobject = '',
        goto_first = '',
        goto_prev = '',
        goto_next = '',
        goto_last = '',
      },
      source = MiniDiff.gen_source.save(),
    }
  end,
}
