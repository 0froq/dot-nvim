return {
  'christoomey/vim-tmux-navigator',
  lazy = false,
  cmd = {
    'TmuxNavigateLeft',
    'TmuxNavigateDown',
    'TmuxNavigateUp',
    'TmuxNavigateRight',
    'TmuxNavigatePrevious',
    'TmuxNavigatorProcessList',
  },
  config = function()
    vim.g.tmux_navigator_no_mappings = 1
    vim.g.tmux_navigator_no_wrap = 1

    local useMap = require('useMap')

    useMap.batch({
      mode = 'n',
      { '<C-h>', ':TmuxNavigateLeft', 'Nav left' },
      { '<C-j>', ':TmuxNavigateDown', 'Nav down' },
      { '<C-k>', ':TmuxNavigateUp', 'Nav up' },
      { '<C-l>', ':TmuxNavigateRight', 'Nav right' },
    })
  end,
}
