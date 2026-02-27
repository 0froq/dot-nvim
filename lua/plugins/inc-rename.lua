local useMap = require('useMap')
return {
  'smjonas/inc-rename.nvim',
  lazy = false,
  opts = {},
  config = function(_, opts)
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
