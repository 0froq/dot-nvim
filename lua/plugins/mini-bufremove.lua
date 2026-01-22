return {
  'nvim-mini/mini.bufremove',
  version = false,
  lazy = false,
  opts = {},
  config = function(_, opts)
    local MiniBufremove = require('mini.bufremove')

    local map = require('utils').map
    local vscode_action = require('utils').vscode_action

    MiniBufremove.setup(opts)

    -- Delete current buffer
    map('n', '<leader>bd', vscode_action(
      MiniBufremove.delete,
      'workbench.action.closeActiveEditor'
    ), 'Buffer delete')

    -- Delete other buffers
    map('n',
      '<leader>bo',
      vscode_action(
        function()
          local bufs = vim.tbl_filter(
            function(buf)
              -- Only deal with file buffers(not special buffers) and skip current buffer
              return buf ~= vim.api.nvim_get_current_buf()
                  and vim.api.nvim_get_option_value('buftype', { buf = buf }) == ''
            end,
            vim.api.nvim_list_bufs()
          )
          for _, buf in ipairs(bufs) do
            MiniBufremove.delete(buf)
          end
        end,
        'workbench.action.closeOtherEditors'
      ), 'Buffer delete')
  end
}
