return {
  'nvim-mini/mini.files',
  version = false,
  lazy = false,
  opts = {
    content = {
      filter = function(data)
        return data.name ~= '.DS_Store'
      end
    },
    mappings = {
      close       = '<esc>',
      go_in       = '',
      go_in_plus  = '<enter>',
      go_out      = '',
      go_out_plus = '<backspace>',
      mark_goto   = "'",
      mark_set    = 'm',
      reset       = '.',
      reveal_cwd  = '@',
      show_help   = 'g?',
      synchronize = '<enter><enter>',
      trim_left   = '',
      trim_right  = '',
    },
    options = {
      -- Whether to delete permanently or move into module-specific trash
      permanent_delete = false,
      -- Whether to use for editing directories
      use_as_default_explorer = true,
    },
    windows = {
      -- Maximum number of windows to show side by side
      -- max_number = math.huge,
      max_number = 2,
      -- Whether to show preview of file/directory under cursor
      preview = true,
      -- Width of focused window
      width_focus = 50,
      -- Width of non-focused window
      width_nofocus = 15,
      -- Width of preview window
      width_preview = 30,
    },
  },
  config = function(_, opts)
    ---@module "mini.files"
    local MiniFiles = require('mini.files')

    local map = require('utils').map
    local vscode_action = require('utils').vscode_action

    MiniFiles.setup(opts)

    -- Open file explorer and focus on current file
    map('n', '-', vscode_action(
      function()
        if not MiniFiles.close() then
          local buf_name = vim.api.nvim_buf_get_name(0)
          -- If buf_name is not in cwd, open cwd instead
          if not vim.startswith(buf_name, vim.fn.getcwd()) then
            buf_name = vim.fn.getcwd()
          end
          MiniFiles.open(buf_name)
          MiniFiles.reveal_cwd()
        else -- If already open, close it
          MiniFiles.close()
        end
      end,
      'breadcrumbs.focusAndSelect'
    ), 'File explorer')

    -- Open file explorer at cwd
    map('n', '_', function()
      MiniFiles.open(vim.fn.getcwd())
    end, 'Open file explorer at cwd')
  end
}
