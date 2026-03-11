return {
  'nvim-mini/mini.comment',
  version = false,
  event = 'BufReadPre',
  opts = function()
    local TsContextCommentstring = require('ts_context_commentstring')

    return {
      options = {
        ignore_blank_line = false,
        custom_commentstring = function()
          return TsContextCommentstring.calculate_commentstring() or vim.bo.commentstring
        end,
      },
    }
  end,
  config = function()
    local MiniComment = require('mini.comment')

    MiniComment.setup()

    local useMap = require('useMap')

    -- Key map
    useMap.nvmap('<leader>/', 'gcc', { desc = 'Comment', remap = true })
    useMap.nvmap('<leader>/', 'gc', { desc = 'Comment', remap = true })
  end
}
