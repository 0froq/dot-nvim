if vim.g.vscode then
  local useMap = require('useMap')

  useMap.batch({
    mode = 'n',
    {
      '[b',
      { vscode = 'workbench.action.previousEditorInGroup', },
      'Previous buffer'
    },
    {
      ']b',
      { vscode = 'workbench.action.nextEditorInGroup', },
      'Next buffer'
    },
  })

  return {}
end
return {
  'nvim-mini/mini.bracketed',
  version = false,
  event = 'VeryLazy',
  opts = {
    indentscope = { suffix = '' },
  },
  config = function(_, opts)
    local MiniBracketed = require('mini.bracketed')

    -- Navigation between buffers with `b`
    useMap.batch({
      mode = 'n',
      {
        { '[b', '<leader>b[' },
        function() MiniBracketed.buffer('backward') end,
        'Previous buffer'
      },
      {
        { ']b', '<leader>b]' },
        function() MiniBracketed.buffer('forward') end,
        'Previous buffer'
      },
      {
        { '[c', '<leader>c[' },
        function() MiniBracketed.comment('backward', { block_side = 'both' }) end,
        'Previous comment'
      },
      {
        { ']c', '<leader>c]' },
        function() MiniBracketed.comment('forward', { block_side = 'both' }) end,
        'Next comment'
      },
      {
        { '[x', '<leader>x[' },
        function() MiniBracketed.conflict('backward') end,
        'Previous conflict'
      },
      {
        { ']x', '<leader>x]' },
        function() MiniBracketed.conflict('forward') end,
        'Next conflict'
      },
      {
        { '[d', '<leader>d[' },
        function() MiniBracketed.diagnostic('backward') end,
        'Previous diagnostic'
      },
      {
        { ']d', '<leader>d]' },
        function() MiniBracketed.diagnostic('forward') end,
        'Next diagnostic'
      },
      {
        { '[i', '<leader>i[' },
        function() MiniBracketed.indent('backward', { change_type = 'diff' }) end,
        'Previous indent scope'
      },
      {
        { ']i', '<leader>i]' },
        function() MiniBracketed.indent('forward', { change_type = 'diff' }) end,
        'Next indent scope'
      },
      {
        { '[l', '<leader>l[' },
        function() MiniBracketed.location('backward') end,
        'Previous location'
      },
      {
        { ']l', '<leader>l]' },
        function() MiniBracketed.location('forward') end,
        'Next location'
      },
      {
        { '[u', '<leader>u[' },
        function() MiniBracketed.undo('backward') end,
        'Previous undo state'
      },
      {
        { ']u', '<leader>u]' },
        function() MiniBracketed.undo('forward') end,
        'Next undo state'
      },
      {
        { '[y', '<leader>y[' },
        function() MiniBracketed.yank('backward') end,
        'Previous yank',
      },
      {
        { ']y', '<leader>y]' },
        function() MiniBracketed.yank('forward') end,
        'Next yank',
      },
    })

    MiniBracketed.setup(opts)
  end
}
