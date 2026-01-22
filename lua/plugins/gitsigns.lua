local useMap = require('useMap')
if vim.g.vscode then
  useMap.batch({
    mode = 'n',
    {
      '[h',
      { vscode = 'workbench.action.editor.previousChange' },
      'Previous Hunk',
    },
    {
      ']h',
      { vscode = 'workbench.action.editor.nextChange' },
      'Next Hunk',
    },
  })

  return {}
end
return {
  'lewis6991/gitsigns.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  opts = {
    -- signs = {
    --   add          = { text = '┃' },
    --   change       = { text = '┃' },
    --   delete       = { text = '_' },
    --   topdelete    = { text = '‾' },
    --   changedelete = { text = '~' },
    --   untracked    = { text = '┆' },
    -- },
    -- signs_staged = {
    --   add          = { text = '┃' },
    --   change       = { text = '┃' },
    --   delete       = { text = '_' },
    --   topdelete    = { text = '‾' },
    --   changedelete = { text = '~' },
    --   untracked    = { text = '┆' },
    -- },
    -- signs_staged_enable = true,
    signcolumn = false,
    numhl = true,
    -- linehl = false,
    -- word_diff = false,
    -- watch_gitdir = {
    --   follow_files = true
    -- },
    -- auto_attach = true,
    -- attach_to_untracked = false,
    -- current_line_blame = false,
    -- current_line_blame_opts = {
    --   virt_text = true,
    --   virt_text_pos = "eol",
    --   delay = 1000,
    --   ignore_whitespace = false,
    --   virt_text_priority = 100,
    --   use_focus = true,
    -- },
    -- current_line_blame_formatter = "<author>, <author_time:%R> - <summary>",
    -- sign_priority = 6,
    -- update_debounce = 100,
    -- status_formatter = nil,
    -- max_file_length = 40000,
    preview_config = {
      border = 'single',
      style = 'minimal',
      relative = 'cursor',
      row = 0,
      col = 1,
    },

  },
  config = function(_, opts)
    -- If not a git repo, don't load gitsigns
    if vim.fn.systemlist('git rev-parse --is-inside-work-tree')[1] ~= 'true' then
      return
    end

    local GitSigns = require('gitsigns')

    GitSigns.setup(opts)

    -- Navigation
    useMap.batch({
      mode = 'n',
      {
        { ']h', '<leader>h]' },
        function()
          ---@diagnostic disable-next-line: param-type-mismatch
          GitSigns.nav_hunk('next', { target = 'all' })
        end,
        'Next Hunk',
      },
      {
        { '[h', '<leader>h[' },
        function()
          ---@diagnostic disable-next-line: param-type-mismatch
          GitSigns.nav_hunk('prev', { target = 'all' })
        end,
        'Previous Hunk',
      },
      {
        '<leader>hs',
        GitSigns.stage_hunk,
        'Stage hunk',
      },
    })
  end,
}
