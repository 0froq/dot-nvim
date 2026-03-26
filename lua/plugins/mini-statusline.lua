if vim.g.vscode then
  return {}
end

return {
  'nvim-mini/mini.statusline',
  version = false,
  event = { 'VimEnter' },
  dependencies = { 'nvim-mini/mini.icons' },
  opts = function()
    local MiniStatusline = require('mini.statusline')

    return {
      set_vim_settings = false,
      content = {
        active = function()
          local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 150 })
          -- local diagnostics   = MiniStatusline.section_diagnostics({ trunc_width = 75 })
          local filename      = MiniStatusline.section_filename({ trunc_width = 150 })
          local fileinfo      = MiniStatusline.section_fileinfo({ trunc_width = 150 })
          local location      = MiniStatusline.section_location({ trunc_width = 75 })

          return MiniStatusline.combine_groups({
            { hl = mode_hl,                  strings = { mode } },
            '%<', -- Mark general truncate point
            { hl = 'MiniStatuslineFilename', strings = { filename } },
            '%=', -- End left alignment
            { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
            { hl = mode_hl,                  strings = { location } },
          })
        end,
        inactive = function()
          return {
            '%t', -- File name
          }
        end,
      },
    }
  end,
}
