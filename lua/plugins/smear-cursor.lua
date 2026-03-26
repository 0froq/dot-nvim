if vim.g.vscode then
  return {}
end
return {
  'sphamba/smear-cursor.nvim',
  lazy = false,
  opts = {
    -- cursor_color = '#e0926d',
    cursor_color = '#87b173',
    stiffness = 0.3,
    trailing_stiffness = 0.1,
    damping = 0.5,
    trailing_exponent = 10,
    never_draw_over_target = true,
    hide_target_hack = true,
    gamma = 1,
    smear_insert_mode = true,
  },
  config = function(_, opts)
    local SmearCursor = require('smear_cursor')
    local useMap = require('useMap')

    SmearCursor.setup(opts)

    useMap.nmap(
      '<leader>xc',
      SmearCursor.toggle,
      'Toggle smear cursor'
    )
  end
}
