return {
  filetypes = { 'lua' },
  cmd = { 'lua-language-server' },
  root_markers = {
    '.emmyrc.json',
    '.luarc.json',
    '.luarc.jsonc',
    '.luacheckrc',
    '.stylua.toml',
    'stylua.toml',
    'selene.toml',
    'selene.yml',
    '.editorconfig',
  },

  on_attach = function(_, bufnr)
    -- vim.api.nvim_create_autocmd('BufWritePre', {
    --   buffer = bufnr,
    --   callback = function()
    --     vim.lsp.buf.format()
    --   end,
    -- })
  end,

  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      codeLens = { enable = true },
      diagnostics = {
        globals = { 'vim' },
        neededFileStatus = {
          ['codestyle-check'] = 'Any',
        },
      },
      hint = {
        enable = true,
        semicolon = 'Disable',
      },
      format = {
        defaultConfig = {
          quote_style = 'single',
          indent_style = 'space',
          indent_size = '2',
        },
      },
      -- workspace = {
      --   library = vim.api.nvim_get_runtime_file('', true),
      --   checkThirdParty = false,
      -- },
    },
  },
}
