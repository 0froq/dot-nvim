return {
  'ibhagwan/fzf-lua',
  dependencies = { 'nvim-mini/mini.icons' },
  lazy = false,
  ---@diagnostic disable: missing-fields
  opts = function()
    local actions = require('fzf-lua.actions')

    return {
      -- 'fzf-tmux',
      defaults = {
        file_icons = 'mini',
        color_icons = true,
        copen = 'botright copen',
      },
      fzf_opts = {
        ['--gutter'] = '▌',
        ['--preview'] = 'bat --color=always --style=plain {}',
        ['--preview-window'] = 'right,60%,border-left,+{2}+3/3',
        ['--border'] = 'sharp',
        ['--border-label-pos'] = '4',
        ['--marker'] = '*',
        ['--pointer'] = '▌',
        ['--separator'] = '─',
        ['--scrollbar'] = '│',
        ['--layout'] = 'reverse',
        ['--info'] = 'right',
        -- ['--height'] = '40%',
        ['--bind'] = 'alt-p:toggle-preview',
        -- ['--tmux'] = 'center,75%,80%',
        ['--highlight-line'] = false,
      },
      previewers = {
        bat = { args = '--color=always --style=plain' },
        bat_native = { args = '--color=always --style=plain' },
      },
      lsp = {
        code_actions = {
          previewer = 'bat'
        }
      },
      winopts = {
        -- width = 80,
        -- height = 0.9,
        -- row = 0.35,
        -- col = 0.50,
        border = 'none',
        backdrop  = 20,
        preview   = {
          layout = 'horizontal',
          border = 'single',
          -- vertical = 'down:10',
          -- hidden = false,
        },
      },
      keymap = {
        builtin = {
          ['<M-p>'] = 'toggle-preview',
        },
        fzf = {
          ['alt-p'] = 'toggle-preview',
        },
      },
      actions = {
        files = {
          ['ctrl-a'] = {
            fn = actions.file_sel_to_qf,
            prefix = 'select-all+',
          },
          ['enter']  = actions.file_edit_or_qf,
          ['ctrl-s'] = actions.file_split,
          ['ctrl-v'] = actions.file_vsplit,
          ['ctrl-e'] = actions.file_tabedit,
          ['alt-h']  = actions.toggle_hidden,
          ['alt-i']  = actions.toggle_ignore,
        },
      },
      files = {
        git_icons  = true,
        cwd_prompt = false,
      },
      buffers = {
      }
    }
  end,
  config = function(_, opts)
    local FzfLua = require('fzf-lua')
    local useMap = require('useMap')

    FzfLua.setup(opts)

    useMap.batch({
      mode = 'n',
      {
        '<leader><leader>f',
        {
          neovim = FzfLua.files,
          vscode = 'workbench.action.quickOpen',
        },
        'Find files'
      },
      {
        '<leader><leader>w',
        {
          neovim = FzfLua.live_grep,
          vscode = 'workbench.action.quickTextSearch',
        },
        'Grep in files'
      },
      {
        '<leader><leader>W',
        {
          neovim = FzfLua.grep_cword,
        },
        'Grep current word in files'
      },
      {
        '<leader><leader>/',
        {
          neovim = FzfLua.blines,
          vscode = 'actions.find'
        },
        'Fuzzy find in current buffer'
      },
      {
        '<leader><leader>gs',
        {
          neovim = FzfLua.git_status,
        },
        'Git status'
      },
      {
        '<leader><leader>h',
        {
          neovim = FzfLua.helptags,
        },
        'Help tags'
      },
      {
        '<leader><leader>b',
        {
          neovim = FzfLua.buffers,
          vscode = 'workbench.action.showAllEditors',
        },
        'Opened buffers'
      },
      {
        '<leader><leader>k',
        {
          neovim = FzfLua.keymaps
        },
        'Keymaps'
      },
      {
        '<leader><leader>H',
        {
          neovim = FzfLua.highlights
        },
        'Highlight groups'
      },
      {
        'gr',
        {
          neovim = FzfLua.lsp_references,
          vscode = 'editor.action.referenceSearch.trigger'
        },
        { desc = 'LSP references' }
      },
      {
        'gd',
        {
          neovim = FzfLua.lsp_definitions,
          vscode = 'editor.action.peekDefinition'
        },
        'LSP definitions'
      },
      {
        'gt',
        {
          neovim = FzfLua.lsp_typedefs,
          vscode = 'editor.action.peekTypeDefinition'
        },
        'LSP type definitions'
      },
      {
        'gi',
        {
          neovim = FzfLua.lsp_implementations,
          vscode = 'editor.action.peekImplementation'
        },
        'LSP implementations'
      },
      {
        '<leader><leader>s',
        {
          neovim = FzfLua.lsp_document_symbols,
        },
        'LSP symbols in current buffer'
      },
      {
        '<leader><leader>a',
        {
          neovim = FzfLua.lsp_code_actions,
        },
        'LSP code actions'
      },
      {
        '<leader><leader>d',
        {
          neovim = function()
            local diagnostics = vim.diagnostic.get(vim.api.nvim_get_current_buf(),
              { lnum = vim.api.nvim_win_get_cursor(0)[1] - 1 })
            if vim.tbl_isempty(diagnostics) then
              FzfLua.diagnostics_document()
            else
              vim.diagnostic.open_float(nil, { border = 'single' })
            end
          end,
          vscode = 'workbench.panel.markers.view.focus'
        },
        'Diagnostics'
      },
    })
  end,
  ---@diagnostic enable: missing-fields
}
