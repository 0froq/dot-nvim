return {
  'nvim-mini/mini.jump2d',
  version = false,
  event = 'VeryLazy',
  opts = {
    labels = 'abcdefghijklmnopqrstuvwxyz',
    view = {
      dim = true,
      n_steps_ahead = 3,
    },
    allowed_lines = {
      below = true,
      current = true,
    },
    mappings = {
      start_jumping = '',
    }
  },
  config = function(_, opts)
    local MiniJump2d = require('mini.jump2d')

    local useMap = require('useMap')

    MiniJump2d.setup(opts)

    useMap.nmap('ss', function()
      MiniJump2d.start(MiniJump2d.builtin_opts.single_character)
    end, { desc = 'Jump char' })
  end,
}
