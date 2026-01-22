return {
  'nvim-mini/mini.extra',
  version = false,
  lazy = false,
  config = function(_, opts)
    local MiniExtra = require('mini.extra')

    local map = require('utils').map
    local vscode_action = require('utils').vscode_action
    local vscode_call = require('utils').vscode_call

    MiniExtra.setup(opts)
    -- LSP mappings
    map('n', 'gD', vscode_action(
      function()
        MiniExtra.pickers.lsp({ scope = 'declaration' })
      end,
      'editor.action.peekDeclaration'
    ), 'Goto declaration')

    map('n', 'gd', vscode_action(
      function()
        MiniExtra.pickers.lsp({ scope = 'definition' })
      end,
      'editor.action.peekDefinition'
    ), 'Goto definition')

    map('n', 'gi', vscode_call(
      function()
        MiniExtra.pickers.lsp({ scope = 'implementation' })
      end,
      'editor.action.peekImplementation'
    ), 'Goto implementation')

    map('n', 'gr', vscode_action(
      function()
        MiniExtra.pickers.lsp({ scope = 'references' })
      end,
      'editor.action.referenceSearch.trigger'
    ), 'Goto reference')

    map('n', 'gt', vscode_action(
      function()
        MiniExtra.pickers.lsp({ scope = 'type_definition' })
      end,
      'editor.action.peekTypeDefinition'
    ), 'Goto type definition')

    map('n', 'gs', vscode_action(
      function()
        MiniExtra.pickers.lsp({ scope = 'document_symbol' })
      end,
      ''
    ), 'Goto document symbol')

    -- map('n', 'gS', vscode_action(
    --   function()
    --     MiniExtra.pickers.lsp({ scope = 'workspace_symbol' })
    --   end,
    --   ''
    -- ), 'Goto workspace symbol')

    -- Other pickers
    map('n', '<leader>fk', vscode_action(
      MiniExtra.pickers.keymaps,
      ''
    ), 'Pick keymaps')

    -- If no diagnostics at cursor, open all diagnostics
    -- else open float for current diagnostics
    map('n', '<leader>dd', vscode_action(
      function()
        local diagnostics = vim.diagnostic.get(vim.api.nvim_get_current_buf(), { lnum = vim.api.nvim_win_get_cursor(0)[1] - 1 })
        if vim.tbl_isempty(diagnostics) then
          MiniExtra.pickers.diagnostic({ scope = 'current' })
        else
          vim.diagnostic.open_float(nil, { border = 'single' })
        end
      end,
      'workbench.panel.markers.view.focus'
    ), 'Pick diagnostics')

    map('n', '<leader>fgc', vscode_action(
      function()
        MiniExtra.pickers.git_commits()
      end,
      'workbench.scm.history.focus'
    ), 'Pick git commits')

    map('n', '<leader>fgh', vscode_action(
      function()
        MiniExtra.pickers.git_hunks()
      end,
      ''
    ), 'Pick git hunks')

    map('n', '<leader>fH', vscode_action(
      function()
        MiniExtra.pickers.hl_groups()
      end,
      ''
    ), 'Pick highlight groups')
    map('n', '<leader>fc', vscode_action(
      function()
        MiniExtra.pickers.colorschemes()
      end,
      ''
    ), 'Pick colorscheme')
    map('n', '<leader>fm', vscode_action(
      function()
        MiniExtra.pickers.marks()
      end,
      ''
    ), 'Pick marks')
    map('n', '<leader>fl', vscode_action(
      function()
        MiniExtra.pickers.list({ scope = 'location' })
      end,
      ''
    ), 'Pick locations')
    map('n', '<leader>fj', vscode_action(
      function()
        MiniExtra.pickers.list({ scope = 'jump' })
      end,
      ''
    ), 'Pick jumps')
  end,
}
