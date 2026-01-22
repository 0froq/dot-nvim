return {
  'nvim-mini/mini.comment',
  version = false,
  lazy = false,
  opts = {
    options = {
      -- ignore_blank_line = true,
    }
  },
  config = function()
    local MiniComment = require('mini.comment')
    local TsContextCommentstring = require('ts_context_commentstring')

    local map = require('utils').map

    MiniComment.setup({
      options = {
        ignore_blank_line = false,
        custom_commentstring = function()
          return TsContextCommentstring.calculate_commentstring() or vim.bo.commentstring
        end,
      },
    })

    -- Key map
    map('n', '<leader>/', 'gcc', { desc = 'Comment', remap = true })
    map('v', '<leader>/', 'gc', { desc = 'Comment', remap = true })
  end
}
