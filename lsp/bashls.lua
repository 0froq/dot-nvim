return {
  cmd = { 'bash-language-server', 'start' },
  filetypes = { 'sh', 'bash', 'zsh' },

  -- 让无扩展名/特殊文件名也更容易被纳入（可选，但对 .zshrc 很有用）
  -- bashls 也支持通过 GLOB_PATTERN 扩展识别范围（见下文）
  --

  -- on_attach = function(client, bufnr)
  --   vim.api.nvim_create_autocmd('BufWritePre', {
  --     buffer = bufnr,
  --     callback = function()
  --       vim.lsp.buf.format({ bufnr = bufnr })
  --     end,
  --   })
  -- end,

  settings = {
    bashIde = {
      -- 可选：调试用
      logLevel = 'debug',
      globPattern = '**/*@(.sh|.inc|.bash|.command|.zsh|zshrc|.zshrc|zsh_*)',

      -- 可选：指定 shfmt 路径（例如 mason 装的），不填则用 PATH 里的 shfmt
      shfmt = {
        path = vim.fn.stdpath('data') .. '/mason/bin/shfmt',
      }
    },
  },
}
