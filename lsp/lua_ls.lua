return {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
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
