return {
  'nvim-telescope/telescope.nvim',
  version = '*',
  dependencies = {
    { 'nvim-lua/plenary.nvim' },
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  },
  lazy = false,
  opts = function()
    local layout_actions = require('telescope.actions.layout')
    local borderchars    = { '─', '│', '─', '│', '┌', '┐', '┘', '└' }

    -- TODO: Ugly, refactor this!
    local entry_display  = require('telescope.pickers.entry_display')
    local MiniIcons      = require('mini.icons')
    MiniIcons.mock_nvim_web_devicons()

    local function global_display_override(e, opts)
      local path = e.path or e.filename or e.value
      if not path or type(path) ~= 'string' then
        return nil
      end

      local icon, icon_hl = MiniIcons.get('file', path)

      local displayer = entry_display.create({
        separator = ' ',
        items = {
          { width = 2 },
          { remaining = true },
        },
      })

      local orig = rawget(e, 'display')
      local orig_display = orig
      if type(orig) == 'function' then
        orig_display = orig(e)
      end

      local function display_fn(entry)
        local text = orig_display
        if type(orig) == 'function' then
          text = orig(entry)
        end
        return displayer({
          { icon, icon_hl },
          { text, nil },
        })
      end

      return display_fn, true
    end

    return {
      defaults = {
        entry_index = {
          display = global_display_override,
        },
        borderchars = {
          prompt  = borderchars,
          results = borderchars,
          preview = borderchars,
        },
        layout_strategy = 'vertical',
        layout_config = {
          vertical = {
            width           = 60,
            prompt_position = 'top',
            mirror          = 'true',
            preview_cutoff  = 20,
            preview_height  = 10,
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
    }
  end,
  config = function(_, opts)
    local Telescope = require('telescope')

    local useMap = require('useMap')

    Telescope.setup(opts)

    local builtin = require('telescope.builtin')

    useMap.batch({
      mode = 'n',
      {
        '<leader><leader>f',
        {
          neovim = builtin.find_files,
          vscode = 'workbench.action.quickOpen',
        },
        'Find files'
      },
      {
        '<leader><leader>w',
        {
          neovim = builtin.live_grep,
          vscode = 'workbench.action.quickTextSearch',
        },
        'Grep in files'
      },
      {
        '<leader><leader>W',
        {
          neovim = builtin.grep_string,
        },
        'Grep current word in files'
      },
      {
        '<leader><leader>/',
        {
          neovim = builtin.current_buffer_fuzzy_find,
          vscode = 'actions.find'
        },
        'Fuzzy find in current buffer'
      },
      {
        '<leader><leader>gs',
        {
          neovim = builtin.git_status,
        },
        'Git status'
      },
      {
        '<leader><leader>h',
        {
          neovim = builtin.help_tags,
        },
        'Help tags'
      },
      {
        '<leader><leader>b',
        {
          neovim = builtin.buffers,
          vscode = 'workbench.action.showAllEditors',
        },
        'Opened buffers'
      },
      {
        '<leader><leader>k',
        {
          neovim = builtin.keymaps
        },
        'Keymaps'
      },
      {
        '<leader><leader>H',
        {
          neovim = builtin.highlights
        },
        'Highlight groups'
      },
      {
        'gr',
        {
          neovim = builtin.lsp_references,
          vscode = 'editor.action.referenceSearch.trigger'
        },
        'LSP references'
      },
      {
        'gd',
        {
          neovim = builtin.lsp_definitions,
          vscode = 'editor.action.peekDefinition'
        },
        'LSP definitions'
      },
      {
        'gt',
        {
          neovim = builtin.lsp_type_definitions,
          vscode = 'editor.action.peekTypeDefinition'
        },
        'LSP type definitions'
      },
      {
        'gi',
        {
          neovim = builtin.lsp_implementations,
          vscode = 'editor.action.peekImplementation'
        },
        'LSP implementations'
      },
      {
        'gs',
        {
          neovim = builtin.lsp_document_symbols,
        },
        'LSP symbols in current buffer'
      },
      {
        '<leader><leader>d',
        {
          neovim = function()
            local diagnostics = vim.diagnostic.get(vim.api.nvim_get_current_buf(),
              { lnum = vim.api.nvim_win_get_cursor(0)[1] - 1 })
            if vim.tbl_isempty(diagnostics) then
              builtin.diagnostics()
            else
              vim.diagnostic.open_float(nil, { border = 'single' })
            end
          end,
          vscode = 'workbench.panel.markers.view.focus'
        },
        'Diagnostics'
      },
    })

    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'TelescopePrompt',
      callback = function()
        local actions = require('telescope.actions')
        local action_state = require('telescope.actions.state')
        useMap.imap('<C-a>', function()
          local picker = action_state.get_current_picker(vim.api.nvim_get_current_buf())
          if picker then
            actions.send_to_qflist(picker.prompt_bufnr)
            actions.open_qflist(picker.prompt_bufnr)
          end
        end, { buffer = true, desc = 'Send all Telescope results to Quickfix' })
      end,
    })
  end
}
