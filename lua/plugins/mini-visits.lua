-- local useMap = require('useMap')

return {
  'nvim-mini/mini.visits',
  version = false,
  event = 'VeryLazy',
  opts = {},
  dependencies = { 'nvim-telescope/telescope.nvim' },
  config = function(_, opts)
    local MiniVisits = require('mini.visits')

    MiniVisits.setup(opts)
  end,
}
