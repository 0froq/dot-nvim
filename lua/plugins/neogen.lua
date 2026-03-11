return {
  'danymat/neogen',
  event = 'VeryLazy',
  opts = {
    snippet_engine = vim.g.vscode and nil or 'mini',
    languages = {
      python = {
        template = {
          annotation_convention = 'google_docstrings',
        },
      },
    },
    placeholders_text = {
      ['description'] = 'desc',
      ['tparam'] = 'tparam',
      ['parameter'] = 'param',
      ['return'] = 'return',
      ['class'] = 'class',
      ['throw'] = 'throw',
      ['varargs'] = 'varargs',
      ['type'] = 'type',
      ['attribute'] = 'attr',
      ['args'] = 'args',
      ['kwargs'] = 'kwargs',
    }
  },
  config = function(_, opts)
    local Neogen = require('neogen')

    local useMap = require('useMap')

    Neogen.setup(opts)

    useMap.nmap('<leader>df', function()
      Neogen.generate({ type = 'func' })
    end, { desc = 'Generate function annotations' })

    useMap.nmap('<leader>dc', function()
      Neogen.generate({ type = 'class' })
    end, { desc = 'Generate class annotations' })

    useMap.nmap('<leader>dt', function()
      Neogen.generate({ type = 'type' })
    end, { desc = 'Generate type annotations' })

    useMap.nmap('<leader>dF', function()
      Neogen.generate({ type = 'file' })
    end, { desc = 'Generate file annotations' })
  end,
}
