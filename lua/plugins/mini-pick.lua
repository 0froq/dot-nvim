return {
  'nvim-mini/mini.pick',
  version = false,
  lazy = false,
  opts = {
    window = {
      prompt_prefix = ' > ',
    }
  },
  config = function(_, opts)
    local MiniPick = require('mini.pick')
    local useMap = require('useMap')

    MiniPick.setup(opts)

    local wipeout_cur = function()
      vim.api.nvim_buf_delete(MiniPick.get_picker_matches().current.bufnr, {})
    end
    local buffer_mappings = { wipeout = { char = '<C-d>', func = wipeout_cur } }

    -- Pick mappings
    useMap.batch({
      mode = 'n',
      {
        '<leader><leader>',
        {
          neovim = MiniPick.builtin.buffers,
          vscode = 'workbench.action.showAllEditors',
        },
        'Pick buffers',
      },
      {
        '<leader>ff',
        {
          neovim = MiniPick.builtin.files,
          vscode = 'workbench.action.quickOpen',
        },
        'Pick files',
      },
      {
        '<leader>fw',
        {
          neovim = function()
            MiniPick.builtin.grep_live({
              ignore_case = true,
              smart_case = true,
            })
          end,
          vscode = 'workbench.action.quickTextSearch',
        },
        'Grep word',
      },
      {
        '<leader>fh',
        function()
          MiniPick.builtin.help({ default_split = 'vertical' })
        end,
        'Pick help',
      }
    })
  end,
}
