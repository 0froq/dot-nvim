return {
  'nvim-mini/mini.bufremove',
  version = false,
  lazy = false,
  opts = {},
  config = function(_, opts)
    local MiniBufremove = require('mini.bufremove')

    local useMap = require('useMap')

    MiniBufremove.setup(opts)

    -- Delete current buffer
    useMap.batch({
      mode = 'n',
      {
        '<leader>bd',
        {
          neovim = MiniBufremove.delete,
          vscode = 'workbench.action.closeActiveEditor'
        },
        'Buffer delete'
      },
      {
        '<leader>bo',
        {
          neovim = function()
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
          vscode = 'workbench.action.closeOtherEditors',
        },
        'Buffer delete'
      }
    })
  end
}
