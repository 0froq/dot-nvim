return {
  'nvim-mini/mini.files',
  version = false,
  lazy = false,
  opts = function()
    return {
      content = {
        filter = function(data)
          return data.name ~= '.DS_Store'
        end,
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
        width_focus = 30,
        -- Width of non-focused window
        width_nofocus = 15,
        -- Width of preview window
        width_preview = 30,
      },
    }
  end,
  config = function(_, opts)
    local MiniFiles = require('mini.files')

    local useMap = require('useMap')

    MiniFiles.setup(opts)

    -- Open file explorer and focus on current file
    useMap.nmap(
      '-',
      {
        neovim = function()
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
        vscode = 'breadcrumbs.focusAndSelect',
      },
      'File explorer'
    )

    useMap.nmap(
      '_',
      function()
        if not MiniFiles.close() then
          MiniFiles.open(vim.fn.getcwd())
        else
          MiniFiles.close()
        end
      end,
      'Open file explorer at cwd'
    )

    local map_split = function(buf_id, lhs, direction)
      local rhs = function()
        -- Make new window and set it as target
        local cur_target = MiniFiles.get_explorer_state().target_window
        local new_target = vim.api.nvim_win_call(cur_target, function()
          vim.cmd(direction .. ' split')
          return vim.api.nvim_get_current_win()
        end)

        MiniFiles.set_target_window(new_target)
        MiniFiles.close()
      end

      -- Adding `desc` will result into `show_help` entries
      local desc = 'Split ' .. direction
      useMap.nmap(lhs, rhs, { buffer = buf_id, desc = desc })
    end

    vim.api.nvim_create_autocmd('User', {
      pattern = 'MiniFilesBufferCreate',
      callback = function(args)
        local buf_id = args.data.buf_id
        -- Tweak keys to your liking
        map_split(buf_id, '<C-s>', 'belowright horizontal')
        map_split(buf_id, '<C-v>', 'belowright vertical')
      end,
    })
  end
}
