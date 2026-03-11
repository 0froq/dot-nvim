if vim.g.vscode then
  return {}
end

return {
  'nvim-mini/mini.indentscope',
  version = false,
  event = 'BufReadPre',
  opts = {
    symbol = '│',
    draw = {
      delay = 0,
      animation = function() return 0 end,
    },
    mappings = {
      object_scope = 'ii',
      object_scope_with_border = 'ai',
      goto_top = '',
      goto_bottom = '',
    },
    options = { try_as_border = true, border = 'both' },
  }
}
