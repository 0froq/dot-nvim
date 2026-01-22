if vim.g.vscode then
  return {}
end
return {
  'nvim-mini/mini.clue',
  version = false,
  lazy = false,
  opts = {},
  config = function(_, opts)
    local MiniClue = require('mini.clue')

    MiniClue.setup({
      window = {
        -- Show window immediately
        delay = 0,

        config = {
          -- Use double-line border
          border = 'single',
        },
      },

      triggers = {
        -- Leader triggers
        { mode = 'n', keys = '<Leader>' },
        { mode = 'x', keys = '<Leader>' },

        -- `[` and `]` keys
        { mode = 'n', keys = '[' },
        { mode = 'n', keys = ']' },

        -- Built-in completion
        { mode = 'i', keys = '<C-x>' },

        -- `g` key
        { mode = 'n', keys = 'g' },
        { mode = 'x', keys = 'g' },

        -- Marks
        { mode = 'n', keys = "'" },
        { mode = 'n', keys = '`' },
        { mode = 'x', keys = "'" },
        { mode = 'x', keys = '`' },

        -- Registers
        { mode = 'n', keys = '"' },
        { mode = 'x', keys = '"' },
        { mode = 'i', keys = '<C-r>' },
        { mode = 'c', keys = '<C-r>' },

        -- Window commands
        { mode = 'n', keys = '<C-w>' },

        -- `z` key
        { mode = 'n', keys = 'z' },
        { mode = 'x', keys = 'z' },
      },

      clues = {
        -- Enhance this by adding descriptions for <Leader> mapping groups
        MiniClue.gen_clues.square_brackets(),
        MiniClue.gen_clues.builtin_completion(),
        MiniClue.gen_clues.g(),
        MiniClue.gen_clues.marks(),
        MiniClue.gen_clues.registers(),
        MiniClue.gen_clues.windows(),
        MiniClue.gen_clues.z(),

        { mode = 'n', keys = '<leader>b[', postkeys = '<leader>b' },
        { mode = 'n', keys = ']w', postkeys = ']' },

        { mode = 'n', keys = '[b', postkeys = '[' },
        { mode = 'n', keys = '[w', postkeys = '[' },
      },
    })
  end,
}
