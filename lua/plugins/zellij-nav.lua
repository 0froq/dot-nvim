return {
  'swaits/zellij-nav.nvim',
  lazy = false,
  cmd = {
    'ZellijNavigateLeftTab',
    'ZellijNavigateDown',
    'ZellijNavigateUp',
    'ZellijNavigateRightTab',
  },
  config = function()
    local ZellijNav = require('zellij-nav')

    ZellijNav.setup()

    local useMap = require('useMap')

    useMap.batch({
      mode = 'n',
      { '<C-h>', ':ZellijNavigateLeftTab',  'Nav left' },
      { '<C-j>', ':ZellijNavigateDown',  'Nav down' },
      { '<C-k>', ':ZellijNavigateUp',    'Nav up' },
      { '<C-l>', ':ZellijNavigateRightTab', 'Nav right' },
    })
  end
}
