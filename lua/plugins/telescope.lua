return {
  'nvim-telescope/telescope.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    -- optional but recommended
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  },
  lazy = false,
  opts = function(opts)
    -- local actions        = require('telescope.actions')
    local layout_actions = require('telescope.actions.layout')

    opts                 = vim.tbl_deep_extend('force', opts or {}, {
      defaults = {
        borderchars = {
          prompt  = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
          results = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
          preview = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
        },
        layout_strategy = 'vertical',
        layout_config = {
          vertical = {
            width           = 40,
            prompt_position = 'top',
            mirror          = 'true',
            preview_cutoff  = 20,
            preview_height  = 10,
            -- height          = 1.0,
            anchor          = 'N',
          },
        },
        preview = {
          hide_on_startup = true,
        },
        sorting_strategy = 'ascending',
        mappings = {
          i = {
            ['<M-p>'] = layout_actions.toggle_preview,
          },
          n = {
            ['p'] = layout_actions.toggle_preview,
          },
        },
      },
    })

    return opts
  end,
  config = function(_, opts)
    local Telescope = require('telescope')

    local useMap = require('useMap')

    Telescope.setup(opts)

    local builtin = require('telescope.builtin')

    useMap.nmap(
      '<leader><leader>f',
      {
        neovim = builtin.find_files,
        vscode = 'workbench.action.quickOpen',
      },
      'Find files'
    )
  end
}
