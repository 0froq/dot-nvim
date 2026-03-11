return {
  cmd = { 'bash-language-server', 'start' },

  filetypes = { 'sh', 'bash', 'zsh' },

  settings = {
    bashIde = {
      logLevel = 'debug',
      globPattern = '**/*@(.sh|.inc|.bash|.command|.zsh|zshrc|.zshrc|zsh_*)',

      shfmt = {
        path = vim.fn.stdpath('data') .. '/mason/bin/shfmt',
      }
    },
  },
}
