return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  branch = 'master',
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
        'markdown_inline',
      },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = true,
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
