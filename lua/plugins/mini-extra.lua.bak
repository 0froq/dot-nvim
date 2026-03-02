return {
  'nvim-mini/mini.extra',
  version = false,
  lazy = false,
  config = function(_, opts)
    local MiniExtra = require('mini.extra')

    -- local map = require('utils').map
    -- local vscode_action = require('utils').vscode_action
    -- local vscode_call = require('utils').vscode_call
    local useMap = require('useMap')

    MiniExtra.setup(opts)

    -- LSP mappings
    useMap.batch({
      mode = 'n',
      {
        'gD',
        {
          neovim = function()
            MiniExtra.pickers.lsp({ scope = 'declaration' })
          end,
          vscode = 'editor.action.peekDeclaration'
        },
        'Goto declaration'
      },
      {
        'gd',
        {
          neovim = function()
            MiniExtra.pickers.lsp({ scope = 'definition' })
          end,
          vscode = 'editor.action.peekDefinition'
        },
        'Goto definition'
      },
      {
        'gi',
        {
          neovim = function()
            MiniExtra.pickers.lsp({ scope = 'implementation' })
          end,
          vscode = 'editor.action.peekImplementation'
        },
        'Goto implementation'
      },
      {
        'gr',
        {
          neovim = function()
            MiniExtra.pickers.lsp({ scope = 'references' })
          end,
          vscode = 'editor.action.referenceSearch.trigger'
        },
        'Goto reference'
      },
      {
        'gt',
        {
          neovim = function()
            MiniExtra.pickers.lsp({ scope = 'type_definition' })
          end,
          vscode = 'editor.action.peekTypeDefinition'
        },
        'Goto type definition'
      },
      {
        'gs',
        {
          neovim = function()
            MiniExtra.pickers.lsp({ scope = 'document_symbol' })
          end,
        },
        'Goto document symbol'
      },
    })

    -- Keymaps
    useMap.nmap(
      '<leader>fk',
      { neovim = MiniExtra.pickers.keymaps, },
      'Pick keymaps'
    )

    useMap.nmap(
      '<leader>dd',
      {
        neovim = function()
          local diagnostics = vim.diagnostic.get(vim.api.nvim_get_current_buf(),
            { lnum = vim.api.nvim_win_get_cursor(0)[1] - 1 })
          if vim.tbl_isempty(diagnostics) then
            MiniExtra.pickers.diagnostic({ scope = 'current' })
          else
            vim.diagnostic.open_float(nil, { border = 'single' })
          end
        end,
        vscode = 'workbench.panel.markers.view.focus'
      },
      'Pick diagnostics'
    )

    -- Git mappings
    useMap.batch({
      mode = 'n',
      {
        '<leader>fgc',
        {
          neovim = function()
            MiniExtra.pickers.git_commits()
          end,
          vscode = 'workbench.scm.history.focus'
        },
        'Pick git commits'
      },
      {
        '<leader>fgh',
        {
          neovim = function()
            MiniExtra.pickers.git_hunks()
          end,
          vscode = ''
        },
        'Pick git hunks'
      },
    })

    -- Highlight groups
    useMap.nmap(
      '<leader>fH',
      {
        neovim = MiniExtra.pickers.hl_groups,
      },
      'Pick highlight groups'
    )

    -- Colorschemes
    useMap.nmap(
      '<leader>fc',
      {
        neovim = MiniExtra.pickers.colorschemes,
      },
      'Pick colorscheme'
    )

    -- Marks
    useMap.nmap(
      '<leader>fm',
      {
        neovim = MiniExtra.pickers.marks,
      },
      'Pick marks'
    )

    -- Location and jump lists
    useMap.batch({
      mode = 'n',
      {
        '<leader>fl',
        {
          neovim = function()
            MiniExtra.pickers.list({ scope = 'location' })
          end,
        },
        'Pick locations'
      },
      {
        '<leader>fj',
        {
          neovim = function()
            MiniExtra.pickers.list({ scope = 'jump' })
          end,
        },
        'Pick jumps'
      },
    })

    -- Visits
    useMap.nmap(
      '<leader>vv',
      {
        neovim = MiniExtra.pickers.visit_paths,
      },
      'Pick visits paths'
    )
  end,
}
