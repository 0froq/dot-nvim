return {
  'nvim-telescope/telescope.nvim',
  version = '*',
  dependencies = {
    { 'nvim-lua/plenary.nvim' },
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  },
  lazy = false,
  opts = function(opts)
    local layout_actions = require('telescope.actions.layout')
    local borderchars = { '─', '│', '─', '│', '┌', '┐', '┘', '└' }

    return {
      defaults = {
        borderchars = {
          -- prompt = { '', '', '', '', '', '', '', '' },
          -- results = { '', '', '', '', '', '', '', '' },
          -- preview = { '', '', '', '', '', '', '', '' },
          prompt  = borderchars,
          results = borderchars,
          preview = borderchars,
          -- prompt  = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
          -- results = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
          -- preview = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
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
  end
}
