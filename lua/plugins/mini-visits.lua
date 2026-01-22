local useMap = require('useMap')

return {
  'nvim-mini/mini.visits',
  version = false,
  event = 'VeryLazy',
  opts = {},
  dependencies = { 'nvim-mini/mini.extra' },
  config = function(_, opts)
    local MiniVisits = require('mini.visits')

    MiniVisits.setup(opts)

    -- useMap.nmap(
    --   '<leader>fv',
    --   MiniVisits.
    --   desc = 'Open Visits List'
    -- )
  end,
}
