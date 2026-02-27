local useMap = require('useMap')

if vim.g.vscode then
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
    indent = { suffix = '' },
    file = { suffix = '' },
  },
  config = function(_, opts)
    local MiniBracketed = require('mini.bracketed')

    -- Buffer navigation
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
        'Next buffer'
      },
      {
        { '[B', '<leader>b{' },
        function() MiniBracketed.buffer('first') end,
        'First buffer'
      },
      {
        { ']B', '<leader>b}' },
        function() MiniBracketed.buffer('last') end,
        'Last buffer'
      },
    })

    useMap.batch({
      mode = 'n',
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
        { '[C', '<leader>c{' },
        function() MiniBracketed.comment('first', { block_side = 'both' }) end,
        'First comment'
      },
      {
        { ']C', '<leader>c}' },
        function() MiniBracketed.comment('last', { block_side = 'both' }) end,
        'Last comment'
      }
    })

    useMap.batch({
      mode = 'n',
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
        { '[X', '<leader>x{' },
        function() MiniBracketed.conflict('first') end,
        'First conflict'
      },
      {
        { ']X', '<leader>x}' },
        function() MiniBracketed.conflict('last') end,
        'Last conflict'
      }
    })

    useMap.batch({
      mode = 'n',
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
        { '[D', '<leader>d{' },
        function() MiniBracketed.diagnostic('first') end,
        'First diagnostic'
      },
      {
        { ']D', '<leader>d}' },
        function() MiniBracketed.diagnostic('last') end,
        'Last diagnostic'
      }
    })

    useMap.batch({
      mode = 'n',
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
        { '[I', '<leader>i{' },
        function() MiniBracketed.indent('first', { change_type = 'diff' }) end,
        'First indent scope'
      },
      {
        { ']I', '<leader>i}' },
        function() MiniBracketed.indent('last', { change_type = 'diff' }) end,
        'Last indent scope'
      }
    })

    useMap.batch({
      mode = 'n',
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
        { '[L', '<leader>l{' },
        function() MiniBracketed.location('first') end,
        'First location'
      },
      {
        { ']L', '<leader>l}' },
        function() MiniBracketed.location('last') end,
        'Last location'
      }
    })

    useMap.batch({
      mode = 'n',
      {
        { '[q', '<leader>q[' },
        function() MiniBracketed.quickfix('backward') end,
        'Previous quickfix'
      },
      {
        { ']q', '<leader>q]' },
        function() MiniBracketed.quickfix('forward') end,
        'Next quickfix'
      },
      {
        { '[Q', '<leader>q{' },
        function() MiniBracketed.quickfix('first') end,
        'First quickfix'
      },
      {
        { ']Q', '<leader>q}' },
        function() MiniBracketed.quickfix('last') end,
        'Last quickfix'
      }
    })

    useMap.batch({
      mode = 'n',
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
        { '[U', '<leader>u{' },
        function() MiniBracketed.undo('first') end,
        'First undo state'
      },
      {
        { ']U', '<leader>u}' },
        function() MiniBracketed.undo('last') end,
        'Last undo state'
      }
    })

    useMap.batch({
      mode = 'n',
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
      {
        { '[Y', '<leader>y{' },
        function() MiniBracketed.yank('first') end,
        'First yank',
      },
      {
        { ']Y', '<leader>y}' },
        function() MiniBracketed.yank('last') end,
        'Last yank',
      }
    })

    MiniBracketed.setup(opts)
  end
}
