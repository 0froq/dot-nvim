return {
  'nvim-mini/mini.jump2d',
  version = false,
  lazy = false,
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

    local map = require('utils').map

    MiniJump2d.setup(opts)

    map('n', 'ss', function()
      MiniJump2d.start(MiniJump2d.builtin_opts.single_character)
    end, { desc = 'Jump char' })
    map('n', '<cr>', function()
      MiniJump2d.start(MiniJump2d.builtin_opts.line_start)
    end, { desc = 'Jump lines', noremap = true, silent = true })

    -- vim.keymap.del("n", "<c-m>")
    -- vim.keymap.del("n", "gri")
    -- vim.keymap.del("n", "grr")
    -- vim.keymap.del("n", "grn")

  end,
}
