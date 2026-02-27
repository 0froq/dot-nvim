return {
  'nvim-mini/mini.completion',
  version = false,
  lazy = false,
  dependencies = {
    'nvim-mini/mini.snippets',
  },
  opts = {
    lsp_completion = {
      source_func = 'omnifunc',
      auto_setup = false
    }
  },
  config = function(opts)
    local MiniCompletion = require('mini.completion')

    local map = require('utils').map

    MiniCompletion.setup(opts)

    -- Setup when LSP attach
    local on_attach = function(args)
      vim.bo[args.buf].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp'
    end
    vim.api.nvim_create_autocmd('LspAttach', { callback = on_attach })

    -- Disable `<Tab>` and `<S-Tab>` mapping from mini.completion
    map('i', '<Tab>', '<Tab>', { desc = 'Keep default Tab behavior' })
    map('i', '<S-Tab>', '<S-Tab>', { desc = 'Keep default Shift-Tab behavior' })

    -- Cancel completion menu with `<Space>`
    -- map('i', '<Space>', function()
    --   if vim.fn.pumvisible() == 1 then
    --     return '<C-e>'
    --   else
    --     return ' '
    --   end
    -- end, { expr = true, desc = 'Cancel completion menu or insert space' })
  end
}
