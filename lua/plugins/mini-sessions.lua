return {
  'nvim-mini/mini.sessions',
  version = false,
  event = 'VimEnter',
  opts = {
    autoread = false,
    autowrite = true,
    directory = '',
    file = '.session.vim',
    force = {
      write = true
    }
  },
  config = function(_, opts)
    local MiniSessions = require('mini.sessions')

    local useMap = require('useMap')

    MiniSessions.setup(opts)

    useMap.nmap('<leader>sw', function()
      MiniSessions.write('.session.vim')
    end, 'Write session')

    useMap.nmap('<leader>sl', function()
      MiniSessions.read()
    end, 'Load last session')
  end
}
