return {
  'smjonas/inc-rename.nvim',
  event = { 'BufReadPost' },
  opts = {},
  config = function(_, opts)
    local useMap = require('useMap')

    local IncRename = require('inc_rename')

    IncRename.setup(opts)

    useMap.nmap(
      '<leader>cr',
      {
        neovim = ':IncRename ',
        vscode = 'editor.action.rename',
      },
      'Rename symbol'
    )
  end
}
