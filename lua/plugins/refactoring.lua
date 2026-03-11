return {
  'ThePrimeagen/refactoring.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  event = 'BufReadPre',
  opts = {
    prompt_func_return_type = {
      go = true,
      java = true,

      cpp = true,
      c = true,
      h = true,
      hpp = true,
      cxx = true,
    },
    prompt_func_param_type = {
      go = true,
      java = true,

      cpp = true,
      c = true,
      h = true,
      hpp = true,
      cxx = true,
    },
  },
  config = function(_, opts)
    local Refactoring = require('refactoring')

    local useMap = require('useMap')

    Refactoring.setup(opts)

    useMap.map('x', '<leader>re', ':Refactor extract ', 'Extract')
    useMap.map('x', '<leader>rF', ':Refactor extract_to_file ', 'Extract to file')
    useMap.map('x', '<leader>rv', ':Refactor extract_var ', 'Extract variable')
    useMap.map({ 'n', 'x' }, '<leader>iv', ':Refactor inline_var<cr>', 'Inline variable')
    useMap.map('n', '<leader>if', ':Refactor inline_func<cr>', 'Inline function')
    useMap.map('n', '<leader>rb', ':Refactor extract_block<cr>', 'Extract block')
    useMap.map('n', '<leader>rB', ':Refactor extract_block_to_file', 'Extract block to file')
  end,
}
