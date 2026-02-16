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

        function()
          local brackets = {
            '[', ']', '{', '}'
          }

          local bracket_objs = {
            'b',
          }

          local bracket_clues = {}

          for _, obj in pairs(bracket_objs) do
            for _, bracket in pairs(brackets) do
              local postkeys = '<leader>' .. obj
              bracket_clues[#bracket_clues + 1] = {
                mode = 'n',
                keys = postkeys .. bracket,
                postkeys = postkeys,
              }
            end
          end

          return bracket_clues
        end,

        function()
          local brackets = {
            '[', ']'
          }

          local bracket_objs = {
            'b',
            'B'
          }

          local bracket_clues = {}

          for _, obj in pairs(bracket_objs) do
            for _, bracket in pairs(brackets) do
              bracket_clues[#bracket_clues + 1] = {
                mode = 'n',
                keys = bracket .. obj,
                postkeys = bracket,
              }
            end
          end
        end
      },
    })
  end,
}
