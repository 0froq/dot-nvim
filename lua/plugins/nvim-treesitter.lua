return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  build = ':TSUpdate',
  dependencies = {
    'RRethy/nvim-treesitter-endwise',
  },
  config = function()
    ---@diagnostic disable-next-line: missing-fields
    require('nvim-treesitter.configs').setup({
      ensure_installed = {
        'bash',
        'c',
        'cpp',
        'css',
        'html',
        'javascript',
        'json',
        'lua',
        'python',
        'rust',
        'typescript',
        'yaml',
        'julia',
        'vue',
        'tsx',
        'go',
        'markdown',
        'vimdoc',
        'typst'
      },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = {
        enable = true,
      },
      autotag = {
        enable = true,
      },
    })
  end,
}
