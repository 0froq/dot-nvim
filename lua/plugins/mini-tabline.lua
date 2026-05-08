return {
  'nvim-mini/mini.tabline',
  version = false,
  event = { 'VimEnter' },
  opts = {},
  config = function(_, opts)
    local MiniTabline = require('mini.tabline')

    local useMap = require('useMap')

    MiniTabline.setup(opts)

    useMap.nmap('<leader>xt',
      {
        neovim = function()
          vim.g.minitabline_disable = not vim.g.minitabline_disable
        end,
        vscode = function()
          local vscode = require('vscode')
          local vscode_tabs = vscode.get_config('workbench.editor.showTabs')
          if vscode_tabs == 'single' then
            vscode.action('workbench.action.showMultipleEditorTabs')
          elseif vscode_tabs == 'multiple' then
            vscode.action('workbench.action.showEditorTab')
          end
        end
      }
      , 'Toggle tabline')

    -- Hide by default
    vim.g.minitabline_disable = true
  end
}
