return {
  'nvim-mini/mini.pick',
  version = false,
  lazy = false,
  opts = {},
  config = function(_, opts)
    local MiniPick = require('mini.pick')

    local map = require('utils').map
    local vscode_action = require('utils').vscode_action
    local useMap = require('useMap')
    local pick_with_rg_config = require('utils').pick_with_rg_config

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
        '<leader>fa',
        {
          neovim = function()
            pick_with_rg_config(MiniPick.builtin.files, 'no-ignore')
          end,
          vscode = '',
        },
        'Pick files (all)',
      }
    })


    map('n', '<leader>fa', vscode_action(
      function()
        pick_with_rg_config(MiniPick.builtin.files, 'no-ignore')
      end,
      ''
    ), 'Pick files (all)')

    map('n', '<leader>fw', vscode_action(
      MiniPick.builtin.grep_live,
      'workbench.action.quickTextSearch'
    ), 'Grep word')

    map('n', '<leader>fh', vscode_action(
      MiniPick.builtin.help,
      ''
    ), 'Pick helps')
  end,
}
